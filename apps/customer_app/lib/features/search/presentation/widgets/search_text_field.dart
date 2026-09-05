import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// حقل البحث نفسه — أيقونة بحث تنفّذ البحث، وزرار فلترة دائري
/// (tune) على اليمين بيفتح SearchFilterSheet.
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onOpenFilters;
  final ValueChanged<String> onSubmitted;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onOpenFilters,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final borderColor = const Color(0xff5A5D5F);

    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: brand.textPrimary),
      decoration: InputDecoration(
        fillColor: brand.surface,
        hintText: strings.searchHint,
        hintStyle: TextStyle(color: brand.textSecondary),
        prefixIcon: IconButton(
          icon: Icon(Icons.search, color: brand.textSecondary),
          onPressed: onSearch,
        ),
        suffixIcon: GestureDetector(
          onTap: onOpenFilters,
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: brand.accent, borderRadius: BorderRadius.circular(100)),
            child: Icon(Icons.tune, color: brand.onAccent),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: borderColor, width: 0.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: borderColor, width: 0.8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
