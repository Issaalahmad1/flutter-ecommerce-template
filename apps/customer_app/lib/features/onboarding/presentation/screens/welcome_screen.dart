import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // مكان الرسمة التوضيحية — استبدلها بصورة حقيقية لاحقًا
              // (Image.asset('assets/onboarding/welcome.png'))
              Icon(Icons.chair_outlined, size: 120, color: brand.accent),
              const SizedBox(height: 40),
              Text(
                'Welcome to\n${brand.appName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Style your spaces & shop for all your decor needs',
                textAlign: TextAlign.center,
                style: TextStyle(color: brand.textSecondary, fontSize: 15),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  );
                },
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}