import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final int quantity;

  const CartItemEntity({required this.productId, required this.quantity});

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(productId: productId, quantity: quantity ?? this.quantity);
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      productId: json['productId'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {'productId': productId, 'quantity': quantity};

  @override
  List<Object?> get props => [productId, quantity];
}
