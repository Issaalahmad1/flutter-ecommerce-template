import '../entities/banner_entity.dart';

abstract class BannerRepository {
  /// [activeOnly] بيفلتر البانرات المعطّلة (isActive: false) — الأدمن
  /// بيقدر يعمل "إيقاف مؤقت" لبانر من غير ما يحذفه نهائيًا.
  Future<List<BannerEntity>> getBanners({bool activeOnly = true});

  Future<void> createBanner(BannerEntity banner);
  Future<void> updateBanner(BannerEntity banner);
  Future<void> deleteBanner(String id);
}