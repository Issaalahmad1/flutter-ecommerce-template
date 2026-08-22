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

  // دوال الأدمن — هنفعّلها لما نبني admin_app، مش محتاجينها في تطبيق العميل دلوقتي.
  @override
  Future<void> createCategory(CategoryEntity category) {
    throw UnimplementedError('استخدم لوحة الأدمن لإضافة فئات جديدة.');
  }

  @override
  Future<void> updateCategory(CategoryEntity category) {
    throw UnimplementedError('استخدم لوحة الأدمن لتعديل الفئات.');
  }

  @override
  Future<void> deleteCategory(String id) {
    throw UnimplementedError('استخدم لوحة الأدمن لحذف الفئات.');
  }
}