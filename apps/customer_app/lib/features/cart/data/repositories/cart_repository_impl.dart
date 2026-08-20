import 'package:decoze_core/core.dart';

import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({CartRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? CartRemoteDataSource();

  @override
  Stream<List<CartItemEntity>> watchCart(String uid) {
    return remoteDataSource
        .watchCart(uid)
        .map((items) => items.map(CartItemEntity.fromJson).toList());
  }

  @override
  Future<void> addToCart(String uid, CartItemEntity item) {
    return remoteDataSource.mutateItems(uid, (items) {
      final index = items.indexWhere((e) => e['productId'] == item.productId);
      if (index != -1) {
        final currentQty = items[index]['quantity'] as int? ?? 1;
        items[index] = {
          'productId': item.productId,
          'quantity': currentQty + item.quantity,
        };
      } else {
        items.add(item.toJson());
      }
      return items;
    });
  }

  @override
  Future<void> updateQuantity(String uid, String productId, int quantity) {
    return remoteDataSource.mutateItems(uid, (items) {
      final index = items.indexWhere((e) => e['productId'] == productId);
      if (index == -1) return items;

      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = {'productId': productId, 'quantity': quantity};
      }
      return items;
    });
  }

  @override
  Future<void> removeFromCart(String uid, String productId) {
    return remoteDataSource.mutateItems(uid, (items) {
      items.removeWhere((e) => e['productId'] == productId);
      return items;
    });
  }

  @override
  Future<void> clearCart(String uid) {
    return remoteDataSource.mutateItems(uid, (_) => []);
  }
}