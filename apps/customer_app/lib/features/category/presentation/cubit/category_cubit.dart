import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  final BannerRepository _bannerRepository;

  CategoryCubit({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
    BannerRepository? bannerRepository,
  })  : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        _bannerRepository = bannerRepository ?? BannerRepositoryImpl(),
        super(const CategoryInitial());

  Future<void> loadCategory(String categoryId) async {
    emit(const CategoryLoading());
    try {
      final results = await Future.wait([
        _categoryRepository.getCategoryById(categoryId),
        _productRepository.getProducts(categoryId: categoryId),
        _bannerRepository.getBanners(),
      ]);

      final banners = results[2] as List<BannerEntity>;
      final activeDiscount = DiscountCalculator.findActiveDiscount(banners, categoryId);

      emit(CategoryLoaded(
        category: results[0] as CategoryEntity,
        products: results[1] as List<ProductEntity>,
        discountPercent: activeDiscount?.discountPercent,
      ));
    } catch (e) {
      emit(const CategoryError('حدث خطأ في تحميل الفئة.'));
    }
  }

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
        discountPercent: currentState.discountPercent, // نحافظ على نفس الخصم بعد الفلترة
      ));
    } catch (e) {
      emit(const CategoryError('حدث خطأ في تحميل المنتجات.'));
    }
  }
}