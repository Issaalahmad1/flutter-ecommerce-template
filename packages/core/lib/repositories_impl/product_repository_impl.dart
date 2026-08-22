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
