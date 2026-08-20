import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  String? _uid;
  StreamSubscription<List<CartItemEntity>>? _subscription;

  CartCubit({
    required CartRepository cartRepository,
    required ProductRepository productRepository,
  })  : _cartRepository = cartRepository,
        _productRepository = productRepository,
        super(const CartInitial());

  /// بيتنفذ لما تتغيّر حالة المستخدم (تسجيل دخول/خروج) — بيبدأ أو
  /// بيوقف مراقبة السلة تبعًا لذلك. راجع BlocListener في main.dart.
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
    final futures = items.map((item) async {
      try {
        final product = await _productRepository.getProductById(item.productId);
        return CartLineItem(product: product, quantity: item.quantity);
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