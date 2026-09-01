import 'package:decoze_core/core.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({ProductRemoteDataSource? remoteDataSource})
    : remoteDataSource = remoteDataSource ?? ProductRemoteDataSource();

  @override
  Future<List<ProductEntity>> getProducts({
    String? categoryId,
    String? subcategoryId,
    bool featuredOnly = false,
  }) async {
    final docs = await remoteDataSource.getProducts(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      featuredOnly: featuredOnly,
    );
    return docs
        .map((doc) => ProductEntity.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final data = await remoteDataSource.getProductById(id);
    if (data == null) {
      throw StateError('المنتج غير موجود: $id');
    }
    return ProductEntity.fromJson(id, data);
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final docs = await remoteDataSource.searchProducts(query);
    return docs
        .map((doc) => ProductEntity.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    final docs = await remoteDataSource.getReviews(productId);
    return docs
        .map((doc) => ReviewEntity.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required double rating,
    required String comment,
  }) {
    final review = ReviewEntity(
      id: '',
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    return remoteDataSource.addReview(productId, review.toJson());
  }

  @override
  Future<void> updateReview({
    required String productId,
    required String reviewId,
    required double rating,
    required String comment,
  }) {
    return remoteDataSource.updateReview(productId, reviewId, {
      'rating': rating,
      'comment': comment,
    });
  }

  @override
  Future<void> deleteReview({required String productId, required String reviewId}) {
    return remoteDataSource.deleteReview(productId, reviewId);
  }

  @override
  Future<void> createProduct(ProductEntity product) {
    return remoteDataSource.createProduct(product.toJson());
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    return remoteDataSource.updateProduct(product.id, product.toJson());
  }

  @override
  Future<void> deleteProduct(String id) {
    return remoteDataSource.deleteProduct(id);
  }
}
