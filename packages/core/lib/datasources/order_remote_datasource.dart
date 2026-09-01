import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// بيسجّل الطلب وفي نفس الوقت بيزوّد `salesCount` لكل منتج فيه —
  /// Batch واحدة عشان لو كتابة أي منتج فشلت، الطلب نفسه ميتسجلش
  /// ناقص. بنستخدم FieldValue.increment بدل قراءة القيمة الحالية
  /// وتعديلها، عشان يفضل صحيح حتى لو أكتر من طلب بيحصل في نفس اللحظة.
  Future<String> createOrder(Map<String, dynamic> orderData) async {
    final orderRef = firestore.collection('orders').doc();
    final batch = firestore.batch();
    batch.set(orderRef, orderData);

    final items = orderData['items'] as List? ?? const [];
    for (final item in items) {
      final itemData = Map<String, dynamic>.from(item as Map);
      final productId = itemData['productId'] as String?;
      final quantity = (itemData['quantity'] as num?)?.toInt() ?? 0;
      if (productId == null || productId.isEmpty || quantity <= 0) continue;
      batch.update(
        firestore.collection('products').doc(productId),
        {'salesCount': FieldValue.increment(quantity)},
      );
    }

    await batch.commit();
    return orderRef.id;
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