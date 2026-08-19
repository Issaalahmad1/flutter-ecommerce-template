import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;

  CategoryCubit({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
  })  : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        super(const CategoryInitial());

  Future<void> loadCategory(String categoryId) async {
    emit(const CategoryLoading());
    try {
      final results = await Future.wait([
        _categoryRepository.getCategoryById(categoryId),
        _productRepository.getProducts(categoryId: categoryId),
      ]);

      emit(CategoryLoaded(
        category: results[0] as CategoryEntity,
        products: results[1] as List<ProductEntity>,
      ));
    } catch (e) {
      emit(const CategoryError('حدث خطأ في تحميل الفئة.'));
    }
  }

  /// لما المستخدم يدوس على تاب فرعي (زي "Sofa" أو "Tables")،
  /// بنفلتر المنتجات المعروضة من غير ما نعمل نداء جديد لـ Firestore —
  /// لأن كل منتجات الفئة أصلاً موجودة عندنا من loadCategory.
  Future<void> filterBySubcategory(String? subcategory) async {
    final currentState = state;
    if (currentState is! CategoryLoaded) return;

    emit(const CategoryLoading());
    try {
      final products = await _productRepository.getProducts(
        categoryId: currentState.category.id,
        subcategoryId: subcategory,
      );
      emit(CategoryLoaded(
        category: currentState.category,
        products: products,
        selectedSubcategory: subcategory,
      ));
    } catch (e) {
      emit(const CategoryError('حدث خطأ في تحميل المنتجات.'));
    }
  }
}