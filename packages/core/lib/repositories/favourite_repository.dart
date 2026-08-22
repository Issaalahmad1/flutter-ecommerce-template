
abstract class FavouriteRepository {
  /// بث مباشر لقائمة IDs المنتجات المفضّلة — مش المنتجات كاملة،
  /// عشان نفصل "هل ده مفضّل؟" عن "تفاصيل المنتج نفسه" (نفس مبدأ
  /// CartRepository بالظبط).
  Stream<List<String>> watchFavoriteIds(String uid);

  Future<void> addFavorite(String uid, String productId);

  Future<void> removeFavorite(String uid, String productId);
}