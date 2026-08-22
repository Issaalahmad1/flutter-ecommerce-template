import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> createOrder(Map<String, dynamic> orderData) async {
    final docRef = await firestore.collection('orders').add(orderData);
    return docRef.id;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getOrders(String uid) async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  Future<Map<String, dynamic>?> getOrderById(String id) async {
    final doc = await firestore.collection('orders').doc(id).get();
    return doc.data();
  }

  Future<void> updateOrderStatus(String id, String status) {
    return firestore.collection('orders').doc(id).update({'status': status});
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllOrders() async {
    final snapshot =
        await firestore.collection('orders').orderBy('createdAt', descending: true).get();
    return snapshot.docs;
  }
}