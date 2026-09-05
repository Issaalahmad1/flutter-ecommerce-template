import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'filter_controls.dart';

class CategoryFilterSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategoryTap;
  final List<String> availableSubcategories;
  final String? selectedSubcategory;
  final ValueChanged<String> onSubcategoryTap;

  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryTap,
    required this.availableSubcategories,
    required this.selectedSubcategory,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionTitle(strings.filterCategories, brand: brand),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in categories)
              FilterOptionChip(
                label: category.name,
                isSelected: selectedCategoryId == category.id,
                brand: brand,
                onTap: () => onCategoryTap(category.id),
              ),
          ],
        ),
        if (availableSubcategories.isNotEmpty) ...[
          const SizedBox(height: 16),
          FilterSectionTitle(strings.filterProducts, brand: brand),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sub in availableSubcategories)
                FilterOptionChip(
                  label: sub,
                  isSelected: selectedSubcategory == sub,
                  brand: brand,
                  onTap: () => onSubcategoryTap(sub),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
