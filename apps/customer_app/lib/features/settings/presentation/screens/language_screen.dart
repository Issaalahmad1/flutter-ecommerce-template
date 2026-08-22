import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'English (US)';

  static const _languages = [
    'English (US)', 'English (UK)', 'Mandarin', 'Hindi', 'Spanish',
    'French', 'Arabic', 'Bengali', 'Russian', 'Indonesia',
  ];

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: ListView(
        children: _languages
            .map((lang) => RadioListTile<String>(
                  title: Text(lang),
                  value: lang,
                  groupValue: _selected,
                  activeColor: brand.accent,
                  onChanged: (v) => setState(() => _selected = v!),
                ))
            .toList(),
      ),
    );
  }
}