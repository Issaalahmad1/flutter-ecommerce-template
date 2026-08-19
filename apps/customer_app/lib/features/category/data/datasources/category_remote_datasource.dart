import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCategories() async {
    final snapshot = await firestore
        .collection('categories')
        .orderBy('order')
        .get();
    return snapshot.docs;
  }

  Future<Map<String, dynamic>?> getCategoryById(String id) async {
    final doc = await firestore.collection('categories').doc(id).get();
    return doc.data();
  }
}