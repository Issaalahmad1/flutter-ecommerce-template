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

  Future<void> addToCart(String productId, {int quantity = 1}) {
    final uid = _uid;
    if (uid == null) return Future.value();
    return _cartRepository.addToCart(
      uid,
      CartItemEntity(productId: productId, quantity: quantity),
    );
  }

  Future<void> updateQuantity(String productId, int quantity) {
    final uid = _uid;
    if (uid == null) return Future.value();
    return _cartRepository.updateQuantity(uid, productId, quantity);
  }

  Future<void> removeItem(String productId) {
    final uid = _uid;
    if (uid == null) return Future.value();
    return _cartRepository.removeFromCart(uid, productId);
  }

  Future<void> clearCart() {
    final uid = _uid;
    if (uid == null) return Future.value();
    return _cartRepository.clearCart(uid);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}