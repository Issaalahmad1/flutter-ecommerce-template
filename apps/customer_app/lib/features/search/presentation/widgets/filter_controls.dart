import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// عناصر صغيرة قابلة لإعادة الاستخدام جوّه SearchFilterSheet — عنوان
/// قسم، chip اختيار، ودائرة لون.
class FilterSectionTitle extends StatelessWidget {
  final String text;
  final BrandConfig brand;

  const FilterSectionTitle(this.text, {super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: brand.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}

class FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final BrandConfig brand;
  final VoidCallback onTap;

  const FilterOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.brand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? brand.accent : brand.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? brand.onAccent : brand.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class ColorOptionSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final BrandConfig brand;
  final VoidCallback onTap;

  const ColorOptionSwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.brand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? brand.accent : Colors.transparent, width: 3),
        ),
        child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
      ),
    );
  }
}
