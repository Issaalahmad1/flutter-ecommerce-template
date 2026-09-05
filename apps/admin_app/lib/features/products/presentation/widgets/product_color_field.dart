import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'product_color_swatch.dart';

class ProductColorField extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String?> onChanged;

  const ProductColorField({super.key, required this.selectedColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color (optional)', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ProductColorSwatch(
              color: null,
              isSelected: selectedColor == null,
              onTap: () => onChanged(null),
            ),
            for (final entry in ProductColorPalette.colors.entries)
              ProductColorSwatch(
                color: ProductColorPalette.toColor(entry.value),
                label: entry.key,
                isSelected: selectedColor == entry.value,
                onTap: () => onChanged(entry.value),
              ),
          ],
        ),
      ],
    );
  }
}
