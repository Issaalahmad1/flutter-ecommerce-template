import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository _categoryRepository;

  CategoriesCubit({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoriesInitial());

  Future<void> loadCategories() async {
    emit(const CategoriesLoading());
    try {
      final categories = await _categoryRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(const CategoriesError('حدث خطأ في تحميل الفئات.'));
    }
  }

  Future<void> createCategory(CategoryEntity category) async {
    await _categoryRepository.createCategory(category);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryEntity category) async {
    await _categoryRepository.updateCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _categoryRepository.deleteCategory(id);
    await loadCategories();
  }
}