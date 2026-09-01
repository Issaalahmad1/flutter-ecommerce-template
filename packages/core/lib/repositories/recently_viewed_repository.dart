/// نفس فكرة FavouriteRepository بالظبط — بث لـ IDs بس (مش المنتجات
/// كاملة)، مرتّبة من الأحدث مشاهدة للأقدم، ومحدودة العدد.
abstract class RecentlyViewedRepository {
  Stream<List<String>> watchRecentlyViewedIds(String uid);

  /// بتتنادى في كل مرة المستخدم بيفتح صفحة تفاصيل منتج. لو المنتج
  /// اتشاف قبل كده، بس بيحدّث توقيت آخر مشاهدة (مش بيكرر السجل).
  Future<void> recordView(String uid, String productId);
}
