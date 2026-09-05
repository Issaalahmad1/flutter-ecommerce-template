/// نقاط توقف بسيطة لعرض الشاشة — بتغطي موبايل عادي، موبايل كبير/تابلت
/// صغير في الوضع الرأسي، وتابلت بالوضع الأفقي. مفيش حاجة معقدة زي
/// device pixel ratio أو platform checks — بس عرض الشاشة المتاح فعليًا،
/// وده اللي بيقرر شكل الـ layout مش نوع الجهاز.
class Responsive {
  static const double _tabletBreakpoint = 600;
  static const double _largeTabletBreakpoint = 900;

  static bool isTablet(double width) => width >= _tabletBreakpoint;

  /// عدد أعمدة شبكة المنتجات — بيزيد تدريجيًا مع العرض المتاح بدل
  /// عمودين ثابتين يبانوا فاضيين وممطوطين على تابلت كبير.
  static int productGridColumns(double width) {
    if (width >= _largeTabletBreakpoint) return 4;
    if (width >= _tabletBreakpoint) return 3;
    return 2;
  }

  /// أقصى عرض للمحتوى نفسه على شاشات عريضة جدًا (تابلت بالعرض) —
  /// بيمنع الصفوف النصية (فورمات، تفاصيل منتج) من الامتداد لعرض
  /// الشاشة كله وتبقى صعبة القراءة.
  static double contentMaxWidth(double width) => width >= _largeTabletBreakpoint ? 900 : width;
}
