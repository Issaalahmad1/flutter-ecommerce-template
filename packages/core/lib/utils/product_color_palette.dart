import 'package:flutter/material.dart';

/// لوحة الألوان الثابتة للمنتجات — نفس الألوان دي بيستخدمها الأدمن وقت
/// إضافة منتج، وبيستخدمها العميل وقت الفلترة بالبحث، عشان القيم دايمًا
/// متطابقة (لو الأدمن اختار لون مش في اللوحة دي، الفلتر مش هيلاقيه).
class ProductColorPalette {
  ProductColorPalette._();

  /// الاسم المعروض بالعربي ← قيمة اللون Hex (المُخزّنة فعليًا في المنتج)
  static const Map<String, String> colors = {
    'بنفسجي': '#8B5CF6',
    'أزرق': '#3B82F6',
    'سماوي': '#06B6D4',
    'برتقالي': '#F97316',
    'أسود': '#1F2937',
    'أبيض': '#F5F5F0',
    'بني': '#8B5E3C',
    'رمادي': '#9CA3AF',
  };

  static Color toColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  static String? nameFor(String? hex) {
    if (hex == null) return null;
    for (final entry in colors.entries) {
      if (entry.value.toUpperCase() == hex.toUpperCase()) return entry.key;
    }
    return null;
  }
}
