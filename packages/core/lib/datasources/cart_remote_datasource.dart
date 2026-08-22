import 'package:cloud_firestore/cloud_firestore.dart';

class CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _cartDoc(String uid) =>
      firestore.collection('carts').doc(uid);

  /// بث مباشر (Real-time) لعناصر السلة.
  Stream<List<Map<String, dynamic>>> watchCart(String uid) {
    return _cartDoc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return [];
      final rawItems = data['items'] as List? ?? const [];
      return rawItems.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    });
  }

  /// ينفّذ تعديل على قائمة العناصر بشكل ذرّي (Atomic Transaction).
  /// بيقرأ آخر نسخة من المستند وبيكتب النسخة المعدّلة في نفس العملية
  /// غير القابلة للمقاطعة — حتى لو نفس المستخدم فتح التطبيق على أكتر
  /// من جهاز في نفس اللحظة بالظبط، Firestore بيتولى إعادة المحاولة
  /// تلقائيًا لمنع ضياع أي تحديث (Lost Update Problem).
  Future<void> mutateItems(
    String uid,
    List<Map<String, dynamic>> Function(List<Map<String, dynamic>> current) mutator,
  ) {
    final docRef = _cartDoc(uid);
    return firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data();
      final rawItems = data?['items'] as List? ?? const [];
      final currentItems =
          rawItems.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      final updatedItems = mutator(currentItems);

      transaction.set(docRef, {'items': updatedItems}, SetOptions(merge: true));
    });
  }
}