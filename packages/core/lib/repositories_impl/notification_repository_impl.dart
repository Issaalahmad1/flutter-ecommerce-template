import 'package:decoze_core/core.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({NotificationRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? NotificationRemoteDataSource();

  @override
  Stream<List<NotificationEntity>> watchForUser(String uid) {
    return remoteDataSource.watchUserNotifications(uid).map(
          (docs) => docs.map((doc) => NotificationEntity.fromJson(doc.id, doc.data())).toList(),
        );
  }

  @override
  Future<void> markUserNotificationRead(String uid, String notificationId) {
    return remoteDataSource.markUserNotificationRead(uid, notificationId);
  }

  @override
  Stream<List<NotificationEntity>> watchForAdmin() {
    return remoteDataSource.watchAdminNotifications().map(
          (docs) => docs.map((doc) => NotificationEntity.fromJson(doc.id, doc.data())).toList(),
        );
  }

  @override
  Future<void> markAdminNotificationRead(String notificationId) {
    return remoteDataSource.markAdminNotificationRead(notificationId);
  }

  @override
  Future<void> notifyAdminNewOrder({
    required String orderId,
    required String customerName,
    required double total,
  }) {
    final notification = NotificationEntity(
      id: '',
      type: NotificationType.newOrder,
      data: {'orderId': orderId, 'customerName': customerName, 'total': total},
      createdAt: DateTime.now(),
    );
    return remoteDataSource.addAdminNotification(notification.toJson());
  }

  @override
  Future<void> notifyUserOrderStatusChanged({
    required String uid,
    required String orderId,
    required String status,
  }) {
    final notification = NotificationEntity(
      id: '',
      type: NotificationType.orderStatusChanged,
      data: {'orderId': orderId, 'status': status},
      createdAt: DateTime.now(),
    );
    return remoteDataSource.addUserNotification(uid, notification.toJson());
  }
}
