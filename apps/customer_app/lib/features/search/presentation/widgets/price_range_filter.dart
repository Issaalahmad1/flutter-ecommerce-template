import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'filter_controls.dart';

class PriceRangeFilter extends StatelessWidget {
  final double maxPrice;
  final ValueChanged<double> onChanged;

  const PriceRangeFilter({super.key, required this.maxPrice, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionTitle(strings.priceRange, brand: brand),
        Slider(
          value: maxPrice,
          min: 0,
          max: 1500,
          divisions: 15,
          activeColor: brand.accent,
          label: '${brand.currencySymbol}${maxPrice.round()}',
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${brand.currencySymbol}0', style: TextStyle(color: brand.textSecondary)),
              Text(
                '${strings.upTo} ${brand.currencySymbol}${maxPrice.round()}',
                style: TextStyle(color: brand.accent, fontWeight: FontWeight.bold),
              ),
              Text('${brand.currencySymbol}1500', style: TextStyle(color: brand.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
