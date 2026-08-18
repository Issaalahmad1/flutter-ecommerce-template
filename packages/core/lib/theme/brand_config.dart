import 'package:flutter/material.dart';

/// كل حاجة خاصة بهوية البراند في مكان واحد.
///
/// الهدف: أي شاشة في customer_app أو admin_app متبقاش فيها نص أو لون
/// Hardcoded. بدل ما تكتب Color(0xFFE4FF4D) أو "decoze" جوه الـ widget،
/// بتقرأ من هنا. لو حبيت تلبس المشروع براند تاني بالكامل، التغيير هنا بس.
///
/// راجع قسم 07 (استراتيجية النشر) في دليل المشروع لفهم السبب.
class BrandConfig {
  final String appName;
  final String tagline;
  final Color primaryBackground;
  final Color surface;
  final Color accent;
  final Color onAccent;
  final Color textPrimary;
  final Color textSecondary;
  final String logoAssetPath;
  final String currencySymbol;
  final String supportEmail;

  const BrandConfig({
    required this.appName,
    required this.tagline,
    required this.primaryBackground,
    required this.surface,
    required this.accent,
    required this.onAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.logoAssetPath,
    required this.currencySymbol,
    required this.supportEmail,
  });

  /// نسخة decoze — الألوان دي مسحوبة فعليًا من ملفات الفيجما اللي بعتّها
  /// (راجع قسم 03 في الدليل، جزء "نموذج توضيحي: قراءة شاشة من التصميم").
  static const BrandConfig decoze = BrandConfig(
    appName: 'decoze',
    tagline: 'Style your spaces & shop for all your decor needs',
    primaryBackground: Color(0xFF20232A),
    surface: Color(0xFF2E3238),
    accent: Color(0xFFE4FF4D),
    onAccent: Color(0xFF20232A),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB4B7BE),
    logoAssetPath: 'assets/brand/logo.png',
    currencySymbol: r'$',
    supportEmail: 'support@decoze.app',
  );
}
