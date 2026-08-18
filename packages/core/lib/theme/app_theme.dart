import 'package:flutter/material.dart';
import 'brand_config.dart';

/// بيبني ThemeData كامل من BrandConfig بدل ما يتكرر نفس التنسيق
/// في كل شاشة. استخدمه في MaterialApp(theme: AppTheme.build(BrandConfig.decoze)).
class AppTheme {
  const AppTheme._();

  static ThemeData build(BrandConfig brand) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: brand.primaryBackground,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brand.accent,
        brightness: Brightness.dark,
        primary: brand.accent,
        onPrimary: brand.onAccent,
        surface: brand.surface,
      ),
      textTheme:  Typography.material2021(platform: TargetPlatform.android)
          .white
          .apply(
            bodyColor: brand.textPrimary,
            displayColor: brand.textPrimary,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: brand.primaryBackground,
        foregroundColor: brand.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brand.accent,
          foregroundColor: brand.onAccent,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brand.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: brand.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: brand.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: brand.primaryBackground,
        selectedItemColor: brand.accent,
        unselectedItemColor: brand.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
