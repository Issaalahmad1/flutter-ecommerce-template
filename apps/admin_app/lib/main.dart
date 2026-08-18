import 'package:decoze_core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: '${brand.appName} Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(brand),
      home: Scaffold(
        body: Center(
          child: Text(
            '${brand.appName} Admin — Phase 1 setup OK ✓',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}