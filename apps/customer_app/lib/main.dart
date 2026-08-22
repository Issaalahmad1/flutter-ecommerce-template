import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'firebase_options.dart';
import 'features/favourite/data/repositories/favourite_repository_impl.dart';
import 'features/favourite/presentation/cubit/favourite_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        if (state is AuthAuthenticated) {
          cartCubit.attachUser(state.user.uid);
          favouriteCubit.attachUser(state.user.uid);
        } else if (state is AuthUnauthenticated) {
          cartCubit.attachUser(null);
          favouriteCubit.attachUser(null);
        }
      },
      child: MaterialApp.router(
        title: DecozeApp.brand.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(DecozeApp.brand),
        routerConfig: router,
      ),
    );
  }
}
