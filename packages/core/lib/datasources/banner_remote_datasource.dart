import 'package:cloud_firestore/cloud_firestore.dart';

class BannerRemoteDataSource {
  final FirebaseFirestore firestore;

  BannerRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// بنجيب كل البانرات مرتّبة بس (من غير فلترة isActive هنا) — عشان
  /// نتجنب الحاجة لـ Composite Index في Firestore (نفس القرار اللي
  /// اتخذناه مع بحث المنتجات). الفلترة بتحصل في الـ Repository لاحقًا.
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBanners() async {
    final snapshot = await firestore.collection('banners').orderBy('order').get();
    return snapshot.docs;
  }

  Future<void> createBanner(Map<String, dynamic> data) {
    return firestore.collection('banners').add(data);
  }

  Future<void> updateBanner(String id, Map<String, dynamic> data) {
    return firestore.collection('banners').doc(id).update(data);
  }

  Future<void> deleteBanner(String id) {
    return firestore.collection('banners').doc(id).delete();
  }
}