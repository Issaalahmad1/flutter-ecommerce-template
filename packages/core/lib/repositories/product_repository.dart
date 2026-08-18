import '../entities/product_entity.dart';
import '../entities/review_entity.dart';

/// عقد مجرد — الـ Cubit في presentation يعرف بس الـ interface ده.
/// التنفيذ الفعلي (Firestore) بيعيش في data/repositories/product_repository_impl.dart
/// جوه كل app (راجع قسم 09 في الدليل).
abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    String? categoryId,
    String? subcategoryId,
    bool featuredOnly = false,
  });

  Future<ProductEntity> getProductById(String id);

  Future<List<ProductEntity>> searchProducts(String query);

  Future<List<ReviewEntity>> getReviews(String productId);

  /// دوال الأدمن — مطلوبة لـ admin_app بس، لكن العقد موحّد
  /// عشان الاتنين يستخدموا نفس الـ Entity ونفس شكل البيانات.
  Future<void> createProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}
