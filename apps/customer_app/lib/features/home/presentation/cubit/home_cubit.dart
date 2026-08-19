import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;

  HomeCubit({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
  })  : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        super(const HomeInitial());

  Future<void> loadHome() async {
    emit(const HomeLoading());
    try {
      // بنجيب الفئات والمنتجات المميزة في نفس الوقت (Future.wait) بدل
      // ما ننتظر واحد يخلص وبعدين نبدأ التاني — بيقلل وقت التحميل.
      final results = await Future.wait([
        _categoryRepository.getCategories(),
        _productRepository.getProducts(featuredOnly: true),
      ]);

      emit(HomeLoaded(
        categories: results[0] as List<CategoryEntity>,
        featuredProducts: results[1] as List<ProductEntity>,
      ));
    } catch (e) {
      emit(HomeError('حدث خطأ في تحميل الصفحة الرئيسية.'));
    }
  }
}