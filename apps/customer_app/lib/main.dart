import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_router.dart';
import 'features/address/presentation/cubit/address_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/notifications/presentation/cubit/notification_center_cubit.dart';
import 'features/recommendations/presentation/cubit/recommendation_cubit.dart';
import 'features/settings/presentation/cubit/locale_cubit.dart';
import 'firebase_options.dart';
import 'features/favourite/presentation/cubit/favourite_cubit.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // في وضع Debug (جهاز المطوّر) بنستخدم Debug provider، وده محتاج تسجيل
  // يدوي لكل جهاز مطوّر في Firebase Console. في وضع Release (نسخة
  // المستخدمين الحقيقيين من المتجر) بنستخدم Play Integrity/App Attest،
  // وده بيتحقق تلقائيًا من كل جهاز من غير أي تسجيل يدوي لكل مستخدم.
  //
  // من غير await عمدًا: activate() ممكن يعمل طلب شبكة (خصوصًا لو Play
  // Services على الجهاز مش مستقر)، ومش عايزين نعلّق بداية تشغيل
  // التطبيق كله لحد ما الطلب ده يخلص — التوكنات بتتجاب lazily وقت
  // الحاجة الفعلية (زي طلبات Firebase AI).
  FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode ? const AppleDebugProvider() : const AppleAppAttestProvider(),
  );
  runApp(const DecozeApp());
}

class DecozeApp extends StatelessWidget {
  const DecozeApp({super.key});

  static const BrandConfig brand = BrandConfig.decoze;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(AuthRepositoryImpl())..listenToAuthChanges(),
        ),
        BlocProvider(
          create: (_) => CartCubit(
            cartRepository: CartRepositoryImpl(),
            productRepository: ProductRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => FavouriteCubit(
            favouriteRepository: FavouriteRepositoryImpl(),
            productRepository: ProductRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => AddressCubit(addressRepository: AddressRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) =>
              NotificationCenterCubit(notificationRepository: NotificationRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) => RecommendationCubit(
            productRepository: ProductRepositoryImpl(),
            orderRepository: OrderRepositoryImpl(),
            favouriteRepository: FavouriteRepositoryImpl(),
            recentlyViewedRepository: RecentlyViewedRepositoryImpl(),
          ),
        ),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: const _AppWithRouter(),
    );
  }
}

/// Widget منفصل بيستخدم Builder جديد عشان نقدر نستخدم context.read
/// للـ Cubits اللي فوق (بعد ما اتعملوا فعليًا في MultiBlocProvider).
class _AppWithRouter extends StatelessWidget {
  const _AppWithRouter();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final router = AppRouter(authCubit).router;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final cartCubit = context.read<CartCubit>();
        final favouriteCubit = context.read<FavouriteCubit>();
        final addressCubit = context.read<AddressCubit>();
        final notificationCenterCubit = context.read<NotificationCenterCubit>();
        final recommendationCubit = context.read<RecommendationCubit>();
        if (state is AuthAuthenticated) {
          cartCubit.attachUser(state.user.uid);
          favouriteCubit.attachUser(state.user.uid);
          addressCubit.attachUser(state.user.uid);
          notificationCenterCubit.attachUser(state.user.uid);
          recommendationCubit.attachUser(state.user.uid);
        } else if (state is AuthUnauthenticated) {
          cartCubit.attachUser(null);
          favouriteCubit.attachUser(null);
          addressCubit.attachUser(null);
          notificationCenterCubit.attachUser(null);
          recommendationCubit.attachUser(null);
        }
      },
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: DecozeApp.brand.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.build(DecozeApp.brand),
            routerConfig: router,
            locale: locale,
            supportedLocales: AppStringsDelegate.supportedLocales,
            localizationsDelegates: const [
              AppStringsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
