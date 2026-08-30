/// المكتبة الثابتة لأيقونات الفئات الجاهزة — مصمّمة من فريق التصميم
/// على فيجما. الأدمن يقدر يختار من هنا بدل ما يرفع صورة يدوي، أو
/// يرفع صورة خاصة لو الفئة مش موجودة في القايمة دي.
class CategoryIconLibrary {
  CategoryIconLibrary._();

  static const String _basePath = 'assets/category_icons';

  /// الاسم المعروض للأدمن ← اسم الملف (من غير امتداد)
  static const Map<String, String> icons = {
    'Bedroom': 'bedroom',
    'Living': 'living',
    'Bath': 'bath',
    'Dining': 'dining',
    'Kitchen': 'kitchen',
    'Office': 'office',
    'Kids': 'kids',
    'Outdoor': 'outdoor',
    'Storage': 'storage',
    'Lighting': 'lighting',
    'Curtains': 'curtains',
    'Decor': 'decor',
    'Furniture': 'furniture',
    'Mirrors': 'merrors',
    'Rugs': 'rugs',
    'Wall Decor': 'wall_decors',
  };

  /// بيحوّل "مفتاح" الأيقونة (زي 'bedroom') لمسار الملف الكامل.
  static String assetPath(String iconKey) => '$_basePath/$iconKey.svg';

  /// بيتحقق هل نص معين (زي imageUrl بتاعة الفئة) هو "مفتاح أيقونة محلية"
  /// وليس رابط شبكة عادي — بنستخدمها وقت العرض عشان نقرر نرسم SVG
  /// محلي ولا صورة من الإنترنت.
  static bool isLocalIcon(String value) => value.startsWith(_basePath);
}