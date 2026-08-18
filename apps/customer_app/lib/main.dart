// ------------------------------------------------------------------
// ده مثال يوضح إزاي تربط BrandConfig + AppTheme + go_router مع بعض.
// انسخه في apps/customer_app/lib/main.dart بعد ما تشغّل:
//   flutterfire configure
// عشان يتولد لك firebase_options.dart الحقيقي بمشروعك.
// ------------------------------------------------------------------

import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart'; // بيتولد أوتوماتيك من flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DecozeApp());
}

class DecozeApp extends StatelessWidget {
  const DecozeApp({super.key});

  // البراند بتاع النسخة دي من التطبيق. لو حبيت تلبسه لبراند تاني،
  // التغيير الوحيد المطلوب هو هنا (أو حتى تجيبه من --dart-define وقت البناء).
  static const BrandConfig brand = BrandConfig.decoze;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: brand.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(brand),
      routerConfig: _router,
    );
  }
}

/// هيكل مبدئي للـ Routing — كل route جديد بيتضاف هنا وقت ما نبني
/// كل feature في المراحل الجاية (راجع قسم 13 - خارطة الطريق).
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _PlaceholderHome(),
    ),
    // GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    // GoRoute(path: '/sign-in', builder: (c, s) => const SignInScreen()),
    // GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
  ],
);

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${DecozeApp.brand.appName} — Phase 1 setup OK ✓',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
