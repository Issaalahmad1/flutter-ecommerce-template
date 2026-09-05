import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// اقتراحات بحث شائعة تظهر قبل ما المستخدم يكتب أي حاجة.
class TopSearches extends StatelessWidget {
  final ValueChanged<String> onTap;

  const TopSearches({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.topSearches,
            style: TextStyle(color: brand.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final term in context.strings.topSearchSuggestions)
                GestureDetector(
                  onTap: () => onTap(term),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: brand.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(term, style: TextStyle(color: brand.textPrimary)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
