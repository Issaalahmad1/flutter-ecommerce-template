import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;
  final BannerRepository _bannerRepository;

  String? _uid;
  StreamSubscription<List<CartItemEntity>>? _subscription;

  /// مؤقّت تأجيل لكل منتج — لو المستخدم بيدوس على +/- بسرعة، مبنبعتش
  /// طلب لـ Firestore على كل ضغطة (الردود ممكن توصل بترتيب مختلف عن
  /// ترتيب الإرسال وترجّع الرقم المعروض لقيمة قديمة). بننتظر لحد ما
  /// المستخدم يستقر على رقم، وبعدين نبعت القيمة النهائية بس مرة واحدة.
  final Map<String, Timer> _quantityDebounceTimers = {};

  CartCubit({
    required CartRepository cartRepository,
    required ProductRepository productRepository,
    BannerRepository? bannerRepository,
  })  : _cartRepository = cartRepository,
        _productRepository = productRepository,
        _bannerRepository = bannerRepository ?? BannerRepositoryImpl(),
        super(const CartInitial());

  void attachUser(String? uid) {
    _subscription?.cancel();
    for (final timer in _quantityDebounceTimers.values) {
      timer.cancel();
    }
    _quantityDebounceTimers.clear();
    _uid = uid;

    if (uid == null) {
      emit(const CartInitial());
      return;
    }

    emit(const CartLoading());
    _subscription = _cartRepository.watchCart(uid).listen(
      (items) async {
        final lineItems = await _buildLineItems(items);
        emit(CartLoaded(items: lineItems));
      },
      onError: (_) => emit(const CartError('حدث خطأ في تحميل السلة.')),
    );
  }

  Future<List<CartLineItem>> _buildLineItems(List<CartItemEntity> items) async {
    // بنجيب البانرات مرة واحدة بس لكل السلة (مش لكل منتج على حدة)،
    // عشان نقلل عدد الطلبات لـ Firestore.
    final banners = await _bannerRepository.getBanners();

    final futures = items.map((item) async {
      try {
        final product = await _productRepository.getProductById(item.productId);
        final discount = DiscountCalculator.findActiveDiscount(banners, product.categoryId);
        return CartLineItem(
          product: product,
          quantity: item.quantity,
          discountPercent: discount?.discountPercent,
        );
      } catch (_) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    return results.whereType<CartLineItem>().toList();
  }

  /// بيضيف المنتج للسلة فورًا محليًا (لو عندنا نسخة المنتج جاهزة، زي
  /// لما بننده من شاشة تفاصيل المنتج)، وبعدين يبعت الكتابة الفعلية
  /// لـ Firestore في الخلفية من غير ما يعلّق الواجهة لحد ما الشبكة
  /// تخلص — عشان المستخدم يحس إن الإضافة حصلت فورًا حتى لو النت بطيء.
  /// الستريم (watchCart) هيصحّح أي فرق تلقائيًا لما البيانات الحقيقية
  /// توصل من السيرفر.
  Future<void> addToCart(
    String productId, {
    int quantity = 1,
    ProductEntity? product,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final currentState = state;
    if (currentState is CartLoaded) {
      final items = [...currentState.items];
      final index = items.indexWhere((e) => e.product.id == productId);
      if (index != -1) {
        items[index] = items[index].copyWith(quantity: items[index].quantity + quantity);
        emit(CartLoaded(items: items));
      } else if (product != null) {
        items.add(CartLineItem(product: product, quantity: quantity));
        emit(CartLoaded(items: items));
      }
    }

    unawaited(_cartRepository.addToCart(
      uid,
      CartItemEntity(productId: productId, quantity: quantity),
    ));
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final uid = _uid;
    if (uid == null) return;

    final currentState = state;
    if (currentState is CartLoaded) {
      final items = [...currentState.items];
      final index = items.indexWhere((e) => e.product.id == productId);
      if (index != -1) {
        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = items[index].copyWith(quantity: quantity);
        }
        emit(CartLoaded(items: items));
      }
    }

    // التحديث المحلي فوق ده بيحصل كل ضغطة، لكن الكتابة الفعلية
    // لـ Firestore متأجّلة — كل ضغطة جديدة بتلغي المؤقّت القديم وتبدأ
    // واحد جديد، فمهما المستخدم دوس بسرعة، غير آخر قيمة مستقرة هي
    // اللي بتتبعت.
    _quantityDebounceTimers[productId]?.cancel();
    _quantityDebounceTimers[productId] = Timer(const Duration(milliseconds: 600), () {
      _quantityDebounceTimers.remove(productId);
      _cartRepository.updateQuantity(uid, productId, quantity);
    });
  }

  Future<void> removeItem(String productId) async {
    final uid = _uid;
    if (uid == null) return;

    final currentState = state;
    if (currentState is CartLoaded) {
      final items = currentState.items.where((e) => e.product.id != productId).toList();
      emit(CartLoaded(items: items));
    }

    unawaited(_cartRepository.removeFromCart(uid, productId));
  }

  Future<void> clearCart() async {
    final uid = _uid;
    if (uid == null) return;

    if (state is CartLoaded) {
      emit(const CartLoaded(items: []));
    }

    unawaited(_cartRepository.clearCart(uid));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    for (final timer in _quantityDebounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
