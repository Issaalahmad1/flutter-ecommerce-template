import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  final BannerRepository _bannerRepository;
  final CategoryRepository _categoryRepository;

  BannersCubit({
    required BannerRepository bannerRepository,
    required CategoryRepository categoryRepository,
  })  : _bannerRepository = bannerRepository,
        _categoryRepository = categoryRepository,
        super(const BannersInitial());

  Future<void> loadBanners() async {
    emit(const BannersLoading());
    try {
      final results = await Future.wait([
        _bannerRepository.getBanners(activeOnly: false),
        _categoryRepository.getCategories(),
      ]);
      emit(BannersLoaded(
        banners: results[0] as List<BannerEntity>,
        categories: results[1] as List<CategoryEntity>,
      ));
    } catch (e) {
      emit(const BannersError('حدث خطأ في تحميل البانرات.'));
    }
  }

  Future<void> createBanner(BannerEntity banner) async {
    await _bannerRepository.createBanner(banner);
    await loadBanners();
  }

  Future<void> updateBanner(BannerEntity banner) async {
    await _bannerRepository.updateBanner(banner);
    await loadBanners();
  }

  Future<void> deleteBanner(String id) async {
    await _bannerRepository.deleteBanner(id);
    await loadBanners();
  }
}