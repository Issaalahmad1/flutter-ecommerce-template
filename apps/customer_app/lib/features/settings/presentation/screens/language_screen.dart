import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/locale_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final currentLocale = context.watch<LocaleCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(strings.languageTitle)),
      body: ListView(
        children: [
          RadioListTile<String>(
            title: Text(strings.languageArabic),
            value: 'ar',
            groupValue: currentLocale.languageCode,
            activeColor: brand.accent,
            onChanged: (_) => context.read<LocaleCubit>().setLocale(const Locale('ar')),
          ),
          RadioListTile<String>(
            title: Text(strings.languageEnglish),
            value: 'en',
            groupValue: currentLocale.languageCode,
            activeColor: brand.accent,
            onChanged: (_) => context.read<LocaleCubit>().setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }
}
