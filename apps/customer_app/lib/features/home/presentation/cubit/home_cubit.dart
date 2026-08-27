import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  final BannerRepository _bannerRepository;

  HomeCubit({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
    BannerRepository? bannerRepository,
  })  : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        _bannerRepository = bannerRepository ?? BannerRepositoryImpl(),
        super(const HomeInitial());

  Future<void> loadHome() async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _categoryRepository.getCategories(),
        _productRepository.getProducts(featuredOnly: true),
        _bannerRepository.getBanners(),
      ]);

      emit(HomeLoaded(
        categories: results[0] as List<CategoryEntity>,
        featuredProducts: results[1] as List<ProductEntity>,
        banners: results[2] as List<BannerEntity>,
      ));
    } catch (e) {
      emit(HomeError('حدث خطأ في تحميل الصفحة الرئيسية.'));
    }
  }
}