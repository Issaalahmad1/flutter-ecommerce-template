import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getProducts({
    String? categoryId,
    String? subcategoryId,
    bool featuredOnly = false,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection('products');

    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (subcategoryId != null) {
      query = query.where('subcategoryId', isEqualTo: subcategoryId);
    }
    if (featuredOnly) {
      query = query.where('isFeatured', isEqualTo: true);
    }

    final snapshot = await query.get();
    return snapshot.docs;
  }

  Future<Map<String, dynamic>?> getProductById(String id) async {
    final doc = await firestore.collection('products').doc(id).get();
    return doc.data();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchProducts(
    String query,
  ) async {
    // Firestore معندوش بحث نصي حر (Full-text search) أصلاً — الحل
    // البسيط هنا هو نجيب كل المنتجات ونفلترهم في الذاكرة. مقبول تمامًا
    // في مشروع بحجم Portfolio (عدد منتجات صغير)، لكن في تطبيق حقيقي
    // بآلاف المنتجات، الحل الصح هيكون خدمة بحث خارجية زي Algolia.
    final snapshot = await firestore.collection('products').get();
    final lowerQuery = query.toLowerCase();
    return snapshot.docs.where((doc) {
      final name = (doc.data()['name'] as String? ?? '').toLowerCase();
      return name.contains(lowerQuery);
    }).toList();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getReviews(
    String productId,
  ) async {
    final snapshot = await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs;
  }

  Future<void> addReview(String productId, Map<String, dynamic> reviewData) async {
    await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .add(reviewData);
    await _recalculateRating(productId);
  }

  Future<void> updateReview(
    String productId,
    String reviewId,
    Map<String, dynamic> reviewData,
  ) async {
    await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(reviewId)
        .update(reviewData);
    await _recalculateRating(productId);
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .doc(reviewId)
        .delete();
    await _recalculateRating(productId);
  }

  /// بيعيد حساب متوسط الـ rating وعدد المراجعات من واقع كل المراجعات
  /// الموجودة فعليًا تحت المنتج — مش بحساب تراكمي (زيادة/نقصان) ممكن
  /// يتراكم فيه خطأ صغير مع الوقت، خصوصًا بعد تعديل أو حذف تقييم.
  Future<void> _recalculateRating(String productId) async {
    final reviewsSnapshot = await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .get();

    final count = reviewsSnapshot.docs.length;
    double rating = 0;
    if (count > 0) {
      final sum = reviewsSnapshot.docs.fold<double>(
        0,
        (total, doc) => total + ((doc.data()['rating'] as num?)?.toDouble() ?? 0),
      );
      rating = double.parse((sum / count).toStringAsFixed(2));
    }

    await firestore.collection('products').doc(productId).update({
      'reviewCount': count,
      'rating': rating,
    });
  }

    Future<void> createProduct(Map<String, dynamic> data) {
    return firestore.collection('products').add(data);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) {
    return firestore.collection('products').doc(id).update(data);
  }

  Future<void> deleteProduct(String id) {
    return firestore.collection('products').doc(id).delete();
  }
}