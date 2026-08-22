import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/cubit/admin_auth_cubit.dart';
import 'features/auth/presentation/cubit/admin_auth_state.dart';
import 'features/auth/presentation/screens/admin_login_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DecozeAdminApp());
}

class DecozeAdminApp extends StatelessWidget {
  const DecozeAdminApp({super.key});

  static const BrandConfig brand = BrandConfig.decoze;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminAuthCubit(authRepository: AuthRepositoryImpl()),
      child: MaterialApp(
        title: '${brand.appName} Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(brand),
        home: const _AuthGate(),
      ),
    );
  }
}

/// بوابة بسيطة — تعرض شاشة اللوجين أو الداشبورد حسب حالة AdminAuthCubit.
/// على عكس customer_app، مش محتاجين go_router هنا لأن الشاشات قليلة
/// ومفيش تنقل عميق — Widget واحد بيحوّل بين حالتين كفاية تمامًا.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAuthCubit, AdminAuthState>(
      builder: (context, state) {
        if (state is AdminAuthAuthenticated) {
          return const DashboardScreen();
        }
        return const AdminLoginScreen();
      },
    );
  }
}