import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// عنصر واحد في شريط التنقل السفلي — أيقونة (أو [customIcon] بدلها،
/// زي إطار صورة البروفايل المتحرّك) + تسمية تحتها.
class NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  /// لو موجودة، بتترسم بدل الأيقونة الافتراضية (زي صورة البروفايل).
  final Widget? customIcon;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(customIcon == null ? 8 : 3),
            decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
            // customIcon (زي إطار صورة البروفايل المتحرّك) بيدير مظهره
            // وإطاره بنفسه — من غير ما نلفّه بحدود تانية هنا.
            child: customIcon ??
                Image.asset(
                  icon,
                  height: 24,
                  width: 24,
                  color: isActive ? brand.accent : brand.textSecondary,
                ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? brand.accent : brand.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
