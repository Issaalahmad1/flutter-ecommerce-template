import 'package:equatable/equatable.dart';
import 'address_entity.dart';

enum OrderStatus { pending, processing, shipped, delivered, canceled }

class OrderItemEntity extends Equatable {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) {
    return OrderItemEntity(
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [productId, name, imageUrl, price, quantity];
}

class TrackingStepEntity extends Equatable {
  final String title;
  final bool isCompleted;
  final DateTime? timestamp;

  const TrackingStepEntity({
    required this.title,
    this.isCompleted = false,
    this.timestamp,
  });

  factory TrackingStepEntity.fromJson(Map<String, dynamic> json) {
    return TrackingStepEntity(
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      timestamp:
          json['timestamp'] != null ? DateTime.tryParse(json['timestamp'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
        'timestamp': timestamp?.toIso8601String(),
      };

  @override
  List<Object?> get props => [title, isCompleted, timestamp];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final AddressEntity shippingAddress;
  final String paymentMethod;
  final OrderStatus status;
  final List<TrackingStepEntity> trackingSteps;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    this.trackingSteps = const [],
    required this.createdAt,
  });

  factory OrderEntity.fromJson(String id, Map<String, dynamic> json) {
    return OrderEntity(
      id: id,
      userId: json['userId'] as String? ?? '',
      items: (json['items'] as List? ?? const [])
          .map((e) => OrderItemEntity.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      shippingAddress: AddressEntity.fromJson(
        'shipping',
        Map<String, dynamic>.from(json['shippingAddress'] as Map? ?? const {}),
      ),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      trackingSteps: (json['trackingSteps'] as List? ?? const [])
          .map((e) => TrackingStepEntity.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'status': status.name,
      'trackingSteps': trackingSteps.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        subtotal,
        tax,
        deliveryFee,
        total,
        shippingAddress,
        paymentMethod,
        status,
        trackingSteps,
        createdAt,
      ];
}
