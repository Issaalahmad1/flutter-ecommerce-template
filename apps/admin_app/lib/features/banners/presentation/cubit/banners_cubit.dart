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
  final conflict = await _findConflictingBanner(banner);
  if (conflict != null) {
    emit(BannersError(
      'يوجد بالفعل بانر نشط ("${conflict.title}") على نفس الفئة. عطّله أو احذفه أولًا.',
    ));
    await loadBanners();
    return;
  }
  await _bannerRepository.createBanner(banner);
  await loadBanners();
}
  Future<void> updateBanner(BannerEntity banner) async {
  final conflict = await _findConflictingBanner(banner, excludeId: banner.id);
  if (conflict != null) {
    emit(BannersError(
      'يوجد بالفعل بانر نشط ("${conflict.title}") على نفس الفئة. عطّله أو احذفه أولًا.',
    ));
    await loadBanners();
    return;
  }
  await _bannerRepository.updateBanner(banner);
  await loadBanners();
}

  Future<void> deleteBanner(String id) async {
    await _bannerRepository.deleteBanner(id);
    await loadBanners();
  }
    /// بتدوّر على بانر تاني نشط بيستهدف نفس الفئة — بس لو البانر الجديد
  /// نفسه هيكون نشط ومرتبط بفئة (مفيش فايدة نمنع بانرات معطّلة أو
  /// عامة من التعارض مع حاجة).
  Future<BannerEntity?> _findConflictingBanner(
    BannerEntity banner, {
    String? excludeId,
  }) async {
    if (!banner.isActive || banner.categoryId == null) return null;

    final allBanners = await _bannerRepository.getBanners(activeOnly: false);
    final now = DateTime.now();

    for (final existing in allBanners) {
      if (existing.id == excludeId) continue;
      if (existing.categoryId != banner.categoryId) continue;
      if (!existing.isActive) continue;
      if (existing.expiresAt != null && existing.expiresAt!.isBefore(now)) continue;
      return existing;
    }
    return null;
  }
}