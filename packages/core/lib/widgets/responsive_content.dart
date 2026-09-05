import 'package:flutter/widgets.dart';

import '../utils/responsive.dart';

/// بيلف أي محتوى (فورم، قائمة، تفاصيل منتج...) بعرض أقصى ويوسّطه —
/// على موبايل عادي مفيش أي فرق محسوس (الشاشة أصلاً أضيق من الحد
/// الأقصى)، لكن على تابلت بالوضع الأفقي بيمنع النصوص والحقول من
/// الامتداد لعرض الشاشة كله وتبقى صعبة القراءة.
class ResponsiveContent extends StatelessWidget {
  final Widget child;

  const ResponsiveContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.contentMaxWidth(MediaQuery.sizeOf(context).width),
        ),
        child: child,
      ),
    );
  }
}
