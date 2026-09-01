import 'dart:async';

import 'package:decoze_core/core.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NotificationRepository notificationRepository;

  OrderRepositoryImpl({
    OrderRemoteDataSource? remoteDataSource,
    NotificationRepository? notificationRepository,
  })  : remoteDataSource = remoteDataSource ?? OrderRemoteDataSource(),
        notificationRepository = notificationRepository ?? NotificationRepositoryImpl();

  @override
  Future<OrderEntity> placeOrder(OrderEntity order) async {
    final id = await remoteDataSource.createOrder(order.toJson());

    // مش محتاجين ننتظر — لو فشل الإشعار لأي سبب، الطلب نفسه اتسجّل
    // فعلًا وده الأهم؛ مش هدف كافي نوقف رحلة الشراء عشانه.
    unawaited(notificationRepository.notifyAdminNewOrder(
      orderId: id,
      customerName: order.shippingAddress.fullName,
      total: order.total,
    ));

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
  Future<void> updateOrderStatus(OrderEntity order, OrderStatus status) async {
    await remoteDataSource.updateOrderStatus(order.id, status.name);
    unawaited(notificationRepository.notifyUserOrderStatusChanged(
      uid: order.userId,
      orderId: order.id,
      status: status.name,
    ));
  }

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final docs = await remoteDataSource.getAllOrders();
    return docs.map((doc) => OrderEntity.fromJson(doc.id, doc.data())).toList();
  }
}