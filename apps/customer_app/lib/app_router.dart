import 'dart:async';

import 'package:customer_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:customer_app/features/home/presentation/screens/home_screen.dart';
import 'package:customer_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:decoze_core/repositories_impl/category_repository_impl.dart';
import 'package:decoze_core/repositories_impl/product_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/onboarding/presentation/screens/welcome_screen.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AuthCubitListenable(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuthScreen =
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';
      final isSplashOrOnboarding = state.matchedLocation == '/splash' ||
    state.matchedLocation == '/welcome' ||
    state.matchedLocation == '/onboarding';

      // لسه ماعرفناش حالة المستخدم (أول تحميل) — سيبه في مكانه.
      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      // مسجّل دخول، لكن واقف في شاشة تسجيل دخول أو Splash — وديه Home.
      if (authState is AuthAuthenticated &&
          (isAuthScreen || isSplashOrOnboarding)) {
        return '/home';
      }

      // مش مسجّل دخول، ومحاول يوصل لـ Home مباشرة — امنعه ووديه Sign in.
      if (authState is AuthUnauthenticated &&
          !isAuthScreen &&
          !isSplashOrOnboarding) {
        return '/sign-in';
      }

      return null; // من غير تحويل
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => BlocProvider(
          create: (_) => HomeCubit(
            categoryRepository: CategoryRepositoryImpl(),
            productRepository: ProductRepositoryImpl(),
          ),
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}

/// go_router محتاج Listenable عشان يعرف "امتى يعيد تقييم الـ redirect".
/// الكلاس ده بيحوّل Stream الخاص بحالة AuthCubit لـ ChangeNotifier
/// بسيط يفهمه go_router.
class _AuthCubitListenable extends ChangeNotifier {
  _AuthCubitListenable(AuthCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
