import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'filter_controls.dart';

class ColorFilterSection extends StatelessWidget {
  final Set<String> selectedColors;
  final ValueChanged<String> onColorTap;

  const ColorFilterSection({super.key, required this.selectedColors, required this.onColorTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionTitle(strings.filterColors, brand: brand),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in ProductColorPalette.colors.entries)
              ColorOptionSwatch(
                color: ProductColorPalette.toColor(entry.value),
                isSelected: selectedColors.contains(entry.value),
                brand: brand,
                onTap: () => onColorTap(entry.value),
              ),
          ],
        ),
      ],
    );
  }
}
