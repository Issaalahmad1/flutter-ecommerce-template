import 'package:decoze_core/core.dart';


class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({OrderRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? OrderRemoteDataSource();

  @override
  Future<OrderEntity> placeOrder(OrderEntity order) async {
    final id = await remoteDataSource.createOrder(order.toJson());
    return OrderEntity(
      id: id,
      userId: order.userId,
      items: order.items,
      subtotal: order.subtotal,
      tax: order.tax,
      deliveryFee: order.deliveryFee,
      total: order.total,
      shippingAddress: order.shippingAddress,
      paymentMethod: order.paymentMethod,
      status: order.status,
      trackingSteps: order.trackingSteps,
      createdAt: order.createdAt,
    );
  }

  @override
  Future<List<OrderEntity>> getOrders(String uid) async {
    final docs = await remoteDataSource.getOrders(uid);
    return docs.map((doc) => OrderEntity.fromJson(doc.id, doc.data())).toList();
  }

  @override
  Future<OrderEntity> getOrderById(String id) async {
    final data = await remoteDataSource.getOrderById(id);
    if (data == null) {
      throw StateError('الطلب غير موجود: $id');
    }
    return OrderEntity.fromJson(id, data);
  }

  @override
  Future<void> updateOrderStatus(String id, OrderStatus status) {
    return remoteDataSource.updateOrderStatus(id, status.name);
  }

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final docs = await remoteDataSource.getAllOrders();
    return docs.map((doc) => OrderEntity.fromJson(doc.id, doc.data())).toList();
  }
}