import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'categories_overview_state.dart';

class CategoriesOverviewCubit extends Cubit<CategoriesOverviewState> {
  final CategoryRepository _categoryRepository;

  CategoriesOverviewCubit({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoriesOverviewInitial());

  Future<void> loadCategories() async {
    emit(const CategoriesOverviewLoading());
    try {
      final categories = await _categoryRepository.getCategories();
      emit(CategoriesOverviewLoaded(categories));
    } catch (e) {
      emit(const CategoriesOverviewError('حدث خطأ في تحميل الفئات.'));
    }
  }
}