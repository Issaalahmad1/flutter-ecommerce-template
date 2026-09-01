import '../entities/product_entity.dart';

/// نتيجة تحليل سؤال البحث بواسطة الذكاء الاصطناعي — فلاتر منظّمة
/// نقدر نستخدمها في استعلام Firestore عادي.
class SearchIntent {
  final List<String> keywords;
  final String? categoryId;
  final double? maxPrice;
  final double? minPrice;

  const SearchIntent({
    required this.keywords,
    this.categoryId,
    this.maxPrice,
    this.minPrice,
  });
}

abstract class SearchRepository {
  /// بياخد سؤال المستخدم بلغة طبيعية (زي "غرفة نوم رخيصة")، ويرجّع
  /// فلاتر بحث منظّمة بعد ما الذكاء الاصطناعي يحللها.
  ///
  /// بنبعت خريطة (اسم الفئة -> ID بتاعها) عشان الذكاء الاصطناعي يتعامل
  /// مع أسماء مفهومة، وإحنا نحوّل الاسم لـ ID صحيح بعدين.
  Future<SearchIntent> parseSearchQuery(String query, Map<String, String> categoryNameToId);

  /// بياخد سؤال المستخدم + قايمة منتجات مرشّحة، ويرجّع IDs المنتجات
  /// اللي فعلاً قريبة من قصد المستخدم (بالمعنى، مش بمطابقة نص حرفية) —
  /// يعني "خشبي" يطابق منتج اسمه "Wooden Chair"، مرتّبة الأكثر صلة الأول.
  Future<List<String>> rankMatchingProducts(String query, List<ProductEntity> candidates);
}