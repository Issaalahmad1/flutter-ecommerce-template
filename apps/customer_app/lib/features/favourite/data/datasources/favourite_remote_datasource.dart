import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteRemoteDataSource {
  final FirebaseFirestore firestore;

  FavouriteRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favCollection(String uid) =>
      firestore.collection('users').doc(uid).collection('favorites');

  Stream<List<String>> watchFavoriteIds(String uid) {
    return _favCollection(uid).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
        );
  }

  Future<void> addFavorite(String uid, String productId) {
    // مستند فاضي تقريبًا — الـ productId نفسه هو الـ Document ID،
    // ده كل اللي محتاجينه لمعرفة "المنتج ده مفضّل". لو حبينا نضيف
    // تاريخ الإضافة بعدين، نضيفه هنا كحقل.
    return _favCollection(uid).doc(productId).set({'addedAt': DateTime.now().toIso8601String()});
  }

  Future<void> removeFavorite(String uid, String productId) {
    return _favCollection(uid).doc(productId).delete();
  }
}