import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyViewedRemoteDataSource {
  final FirebaseFirestore firestore;

  RecentlyViewedRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      firestore.collection('users').doc(uid).collection('recentlyViewed');

  Stream<List<String>> watchRecentlyViewedIds(String uid) {
    return _collection(uid)
        .orderBy('viewedAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> recordView(String uid, String productId) {
    return _collection(uid)
        .doc(productId)
        .set({'viewedAt': DateTime.now().toIso8601String()});
  }
}
