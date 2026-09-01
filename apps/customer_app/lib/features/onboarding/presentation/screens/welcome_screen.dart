import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // مكان الرسمة التوضيحية — استبدلها بصورة حقيقية لاحقًا
              // (Image.asset('assets/onboarding/welcome.png'))
              const Spacer(),
              Column(
                children: [
                  Image.asset(brand.logoAssetPath, width: 120, height: 120),
                  const SizedBox(height: 0),
                  Text(
                    strings.welcomeTo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    brand.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: brand.accent),
                  ),
                ],
              ),
              const SizedBox(height: 72),
              Text(
                strings.welcomeTagline,
                textAlign: TextAlign.center,
                style: TextStyle(color: brand.textSecondary, fontSize: 15),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
                child: Text(strings.getStarted),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
