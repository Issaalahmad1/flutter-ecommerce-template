import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DecozeApp());
}

class DecozeApp extends StatelessWidget {
  const DecozeApp({super.key});

  static const BrandConfig brand = BrandConfig.decoze;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepositoryImpl())..listenToAuthChanges(),
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          final router = AppRouter(authCubit).router;

          return MaterialApp.router(
            title: brand.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.build(brand),
            routerConfig: router,
          );
        },
      ),
    );
  }
}