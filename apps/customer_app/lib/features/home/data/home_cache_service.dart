import 'dart:convert';

import 'package:decoze_core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCache {
  final List<CategoryEntity> categories;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> allProducts;
  final List<BannerEntity> banners;

  const HomeCache({
    required this.categories,
    required this.featuredProducts,
    required this.allProducts,
    required this.banners,
  });
}

/// تخزين محلي بسيط لآخر نسخة من بيانات الصفحة الرئيسية — بنعرضها
/// فورًا لما التطبيق يفتح (من غير "دايرة تحميل")، وبعدين بنحدّثها
/// بهدوء في الخلفية لما بيانات جديدة توصل من Firestore، من غير ما
/// نضطر المستخدم ينتظر شاشة فاضية.
class HomeCacheService {
  static const _key = 'home_cache_v2';

  Future<HomeCache?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return HomeCache(
        categories: (json['categories'] as List)
            .map((e) => CategoryEntity.fromJson(
                  e['id'] as String,
                  e as Map<String, dynamic>,
                ))
            .toList(),
        featuredProducts: (json['products'] as List)
            .map((e) => ProductEntity.fromJson(
                  e['id'] as String,
                  e as Map<String, dynamic>,
                ))
            .toList(),
        allProducts: (json['allProducts'] as List)
            .map((e) => ProductEntity.fromJson(
                  e['id'] as String,
                  e as Map<String, dynamic>,
                ))
            .toList(),
        banners: (json['banners'] as List)
            .map((e) => BannerEntity.fromJson(
                  e['id'] as String,
                  e as Map<String, dynamic>,
                ))
            .toList(),
      );
    } catch (_) {
      // نسخة قديمة/تالفة من الكاش — نتجاهلها ونرجع null بدل ما نكسر
      // الشاشة، وهيتحمّل بيانات جديدة من Firestore عادي.
      return null;
    }
  }

  Future<void> write(HomeCache cache) async {
    final prefs = await SharedPreferences.getInstance();
    final json = {
      'categories': cache.categories.map((c) => {...c.toJson(), 'id': c.id}).toList(),
      'products': cache.featuredProducts.map((p) => {...p.toJson(), 'id': p.id}).toList(),
      'allProducts': cache.allProducts.map((p) => {...p.toJson(), 'id': p.id}).toList(),
      'banners': cache.banners.map((b) => {...b.toJson(), 'id': b.id}).toList(),
    };
    await prefs.setString(_key, jsonEncode(json));
  }
}
