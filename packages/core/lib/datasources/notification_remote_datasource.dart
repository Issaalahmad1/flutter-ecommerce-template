import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userNotifications(String uid) =>
      firestore.collection('users').doc(uid).collection('notifications');

  CollectionReference<Map<String, dynamic>> get _adminNotifications =>
      firestore.collection('admin_notifications');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> watchUserNotifications(
    String uid,
  ) {
    return _userNotifications(uid)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> markUserNotificationRead(String uid, String notificationId) {
    return _userNotifications(uid).doc(notificationId).update({'isRead': true});
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> watchAdminNotifications() {
    return _adminNotifications
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> markAdminNotificationRead(String notificationId) {
    return _adminNotifications.doc(notificationId).update({'isRead': true});
  }

  Future<void> addUserNotification(String uid, Map<String, dynamic> data) {
    return _userNotifications(uid).add(data);
  }

  Future<void> addAdminNotification(Map<String, dynamic> data) {
    return _adminNotifications.add(data);
  }
}
