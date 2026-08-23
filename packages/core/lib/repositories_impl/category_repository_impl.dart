import 'package:decoze_core/core.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({CategoryRemoteDataSource? remoteDataSource})
    : remoteDataSource = remoteDataSource ?? CategoryRemoteDataSource();

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final docs = await remoteDataSource.getCategories();
    return docs
        .map((doc) => CategoryEntity.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<CategoryEntity> getCategoryById(String id) async {
    final data = await remoteDataSource.getCategoryById(id);
    if (data == null) {
      throw StateError('الفئة غير موجودة: $id');
    }
    return CategoryEntity.fromJson(id, data);
  }

  @override
  Future<void> createCategory(CategoryEntity category) {
    return remoteDataSource.createCategory(category.id, category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryEntity category) {
    return remoteDataSource.updateCategory(category.id, category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) {
    return remoteDataSource.deleteCategory(id);
  }
}
