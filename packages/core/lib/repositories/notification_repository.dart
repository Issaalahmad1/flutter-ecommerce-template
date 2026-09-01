import '../entities/notification_entity.dart';

/// عقد موحّد للاتجاهين — إشعارات المستخدم (فردية، تحت مستنده) وإشعارات
/// الأدمن (مشتركة، أي حساب أدمن يشوفها). الاتنين بيرجعوا نفس الـ Entity
/// عشان الـ UI في التطبيقين يقدر يستخدم نفس الـ widget لعرض القائمة.
abstract class NotificationRepository {
  Stream<List<NotificationEntity>> watchForUser(String uid);
  Future<void> markUserNotificationRead(String uid, String notificationId);

  Stream<List<NotificationEntity>> watchForAdmin();
  Future<void> markAdminNotificationRead(String notificationId);

  /// بينادَى من OrderRepositoryImpl.placeOrder — أي حساب أدمن هيشوفها.
  Future<void> notifyAdminNewOrder({
    required String orderId,
    required String customerName,
    required double total,
  });

  /// بينادَى من OrderRepositoryImpl.updateOrderStatus — بتوصل لصاحب
  /// الطلب بس.
  Future<void> notifyUserOrderStatusChanged({
    required String uid,
    required String orderId,
    required String status,
  });
}
