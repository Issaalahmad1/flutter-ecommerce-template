import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// صف قائمة كامل العرض (أيقونة + عنوان + trailing اختياري) — للغة
/// وتسجيل الخروج، بعكس ProfileMenuGrid اللي بيتحط جوّه شبكة.
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Container(
      decoration: BoxDecoration(color: brand.surface, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: titleColor),
        title: Text(title, style: TextStyle(color: titleColor)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
