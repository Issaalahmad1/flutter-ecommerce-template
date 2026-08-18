import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Stream<List<CartItemEntity>> watchCart(String uid);

  Future<void> addToCart(String uid, CartItemEntity item);

  Future<void> updateQuantity(String uid, String productId, int quantity);

  Future<void> removeFromCart(String uid, String productId);

  Future<void> clearCart(String uid);
}
