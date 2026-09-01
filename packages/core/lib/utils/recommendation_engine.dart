import '../entities/product_entity.dart';

/// نظام توصية بسيط قائم على المحتوى (Content-based) — من غير أي نداء
/// لخدمة خارجية، عشان يفضل فوري ومجاني على كل فتحة للصفحة الرئيسية.
///
/// الفكرة: كل فئة (categoryId) بتاخد "وزن اهتمام" حسب تفاعل المستخدم
/// معاها — الشراء أقوى إشارة (3)، بعده المفضلة (2)، بعده مجرد تصفح
/// المنتج (1). بعدين بنرشّح كتالوج المنتجات (من غير اللي المستخدم
/// شافها/اشتراها/فضّلها أصلاً) حسب الفئات الأعلى وزنًا، وبنكسر
/// التعادل بالتقييم ثم عدد المبيعات.
///
/// لو مفيش أي إشارة خالص (مستخدم جديد)، بنرجع لأعلى المنتجات تقييمًا
/// كبديل افتراضي بدل ما القسم يفضل فاضي.
class RecommendationEngine {
  static List<ProductEntity> recommend({
    required List<ProductEntity> allProducts,
    required List<String> purchasedProductIds,
    required List<String> favoriteProductIds,
    required List<String> recentlyViewedProductIds,
    int limit = 10,
  }) {
    final productsById = {for (final p in allProducts) p.id: p};
    final interactedIds = {
      ...purchasedProductIds,
      ...favoriteProductIds,
      ...recentlyViewedProductIds,
    };

    final categoryWeights = <String, double>{};
    void addWeight(Iterable<String> ids, double weight) {
      for (final id in ids) {
        final categoryId = productsById[id]?.categoryId;
        if (categoryId == null) continue;
        categoryWeights[categoryId] = (categoryWeights[categoryId] ?? 0) + weight;
      }
    }

    addWeight(purchasedProductIds, 3);
    addWeight(favoriteProductIds, 2);
    addWeight(recentlyViewedProductIds, 1);

    if (categoryWeights.isEmpty) {
      final fallback = [...allProducts]..sort((a, b) => b.rating.compareTo(a.rating));
      return fallback.take(limit).toList();
    }

    final candidates = allProducts.where((p) => !interactedIds.contains(p.id)).toList()
      ..sort((a, b) {
        final weightCompare =
            (categoryWeights[b.categoryId] ?? 0).compareTo(categoryWeights[a.categoryId] ?? 0);
        if (weightCompare != 0) return weightCompare;
        final ratingCompare = b.rating.compareTo(a.rating);
        if (ratingCompare != 0) return ratingCompare;
        return b.salesCount.compareTo(a.salesCount);
      });

    final result = candidates.take(limit).toList();
    if (result.length < limit) {
      // مفيش كفاية منتجات في نفس الفئات المفضّلة — نكمّل العدد بأعلى
      // المنتجات تقييمًا من باقي الكتالوج عشان القسم مايبانش فاضي.
      final usedIds = {...interactedIds, ...result.map((p) => p.id)};
      final filler = allProducts.where((p) => !usedIds.contains(p.id)).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
      result.addAll(filler.take(limit - result.length));
    }
    return result;
  }
}
