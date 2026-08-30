import '../entities/banner_entity.dart';

class DiscountCalculator {
  DiscountCalculator._();

  /// بيدوّر على بانر نشط (isActive + مش منتهي) بيستهدف الفئة دي تحديدًا.
  /// بيرجّع null لو مفيش خصم ساري على الفئة دي دلوقتي.
  static BannerEntity? findActiveDiscount(
    List<BannerEntity> banners,
    String categoryId,
  ) {
    final now = DateTime.now();
    for (final banner in banners) {
      if (banner.categoryId != categoryId) continue;
      if (!banner.isActive) continue;
      if (banner.expiresAt != null && banner.expiresAt!.isBefore(now)) continue;
      return banner;
    }
    return null;
  }

  /// بيحسب السعر بعد تطبيق نسبة الخصم (لو موجودة). لو discountPercent
  /// null أو صفر، بيرجّع نفس السعر الأصلي من غير تعديل.
  static double applyDiscount(double originalPrice, int? discountPercent) {
    if (discountPercent == null || discountPercent <= 0) return originalPrice;
    return originalPrice - (originalPrice * discountPercent / 100);
  }
}