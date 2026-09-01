import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/home_cache_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CategoryRepository _categoryRepository;
  final ProductRepository _productRepository;
  final BannerRepository _bannerRepository;
  final HomeCacheService _cacheService;

  HomeCubit({
    required CategoryRepository categoryRepository,
    required ProductRepository productRepository,
    BannerRepository? bannerRepository,
    HomeCacheService? cacheService,
  })  : _categoryRepository = categoryRepository,
        _productRepository = productRepository,
        _bannerRepository = bannerRepository ?? BannerRepositoryImpl(),
        _cacheService = cacheService ?? HomeCacheService(),
        super(const HomeInitial());

  Future<void> loadHome() async {
    // أول مرة بس (مفيش بيانات معروضة أصلاً) بنحاول نعرض آخر نسخة
    // متخزّنة محليًا فورًا، أو دايرة تحميل لو مفيش كاش خالص. أي نداء
    // تاني (Pull-to-refresh مثلاً) بيفضل عارض البيانات القديمة ويحدّثها
    // في الخلفية من غير ما يمسح الشاشة.
    if (state is HomeInitial) {
      final cached = await _cacheService.read();
      if (cached != null) {
        emit(HomeLoaded(
          categories: cached.categories,
          featuredProducts: cached.featuredProducts,
          allProducts: cached.allProducts,
          banners: cached.banners,
        ));
      } else {
        emit(const HomeLoading());
      }
    }

    try {
      final results = await Future.wait([
        _categoryRepository.getCategories(),
        _productRepository.getProducts(featuredOnly: true),
        _productRepository.getProducts(),
        _bannerRepository.getBanners(),
      ]);

      final categories = results[0] as List<CategoryEntity>;
      final featuredProducts = results[1] as List<ProductEntity>;
      final allProducts = results[2] as List<ProductEntity>;
      final banners = results[3] as List<BannerEntity>;

      emit(HomeLoaded(
        categories: categories,
        featuredProducts: featuredProducts,
        allProducts: allProducts,
        banners: banners,
      ));

      unawaited(_cacheService.write(HomeCache(
        categories: categories,
        featuredProducts: featuredProducts,
        allProducts: allProducts,
        banners: banners,
      )));
    } catch (e) {
      // لو عندنا بيانات معروضة بالفعل (من الكاش أو تحميل سابق) وفشل
      // التحديث، نسيبها زي ما هي بدل ما نستبدلها برسالة خطأ مفاجئة.
      if (state is! HomeLoaded) {
        emit(HomeError('حدث خطأ في تحميل الصفحة الرئيسية.'));
      }
    }
  }
}
