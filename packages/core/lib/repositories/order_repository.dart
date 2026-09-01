import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<OrderEntity> placeOrder(OrderEntity order);

  Future<List<OrderEntity>> getOrders(String uid);

  Future<OrderEntity> getOrderById(String id);

  /// دالة أدمن — لتحديث حالة الطلب من لوحة التحكم. بتاخد الطلب كامل
  /// (مش الـ id بس) عشان نعرف نبعت إشعار لصاحبه (userId).
  Future<void> updateOrderStatus(OrderEntity order, OrderStatus status);

  /// دوال أدمن — كل الطلبات في النظام (مش بس طلبات مستخدم واحد).
  Future<List<OrderEntity>> getAllOrders();
}
