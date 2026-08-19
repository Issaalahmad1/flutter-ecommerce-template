import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

/// شاشة بسيطة بتتعرض لحظة فتح التطبيق، وبعد تأخير قصير بتنقل تلقائي
/// لشاشة الترحيب. لاحظ إنها StatefulWidget مش Stateless — محتاجينها
/// Stateful عشان نقدر نستخدم initState لجدولة التنقل التلقائي.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    return Scaffold(
      backgroundColor: brand.primaryBackground,
      body: Center(
        child: Text(
          brand.appName,
          style: TextStyle(
            color: brand.accent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}