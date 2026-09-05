import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../cubit/search_state.dart';
import 'category_filter_section.dart';
import 'color_filter_section.dart';
import 'price_range_filter.dart';

/// نافذة الفلترة اليدوية (سعر/فئة/فئة فرعية/لون) — بتترجع [SearchFilters]
/// جديدة لما المستخدم يضغط "Apply"، أو null لو قفل من غير تطبيق.
class SearchFilterSheet extends StatefulWidget {
  final SearchFilters initialFilters;

  const SearchFilterSheet({super.key, required this.initialFilters});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late String? _categoryId;
  late String? _subcategory;
  late double _maxPrice;
  late Set<String> _colors;

  List<CategoryEntity> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.initialFilters.categoryId;
    _subcategory = widget.initialFilters.subcategory;
    _maxPrice = widget.initialFilters.maxPrice;
    _colors = {...widget.initialFilters.colors};
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await CategoryRepositoryImpl().getCategories();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _loadingCategories = false;
    });
  }

  /// الفئات الفرعية المتاحة للاختيار: لو فيه فئة محددة بنعرض فئاتها
  /// الفرعية بس، ولو مفيش نجمع كل الفئات الفرعية من كل الفئات.
  List<String> get _availableSubcategories {
    if (_categoryId != null) {
      final category = _categories.where((c) => c.id == _categoryId);
      return category.isEmpty ? const [] : category.first.subcategories;
    }
    return _categories.expand((c) => c.subcategories).toSet().toList();
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      _categoryId = _categoryId == categoryId ? null : categoryId;
      if (!_availableSubcategories.contains(_subcategory)) {
        _subcategory = null;
      }
    });
  }

  void _toggleSubcategory(String subcategory) {
    setState(() => _subcategory = _subcategory == subcategory ? null : subcategory);
  }

  void _toggleColor(String color) {
    setState(() {
      if (_colors.contains(color)) {
        _colors.remove(color);
      } else {
        _colors.add(color);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: brand.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: brand.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  strings.filterTitle,
                  style: TextStyle(
                    color: brand.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: _loadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          PriceRangeFilter(
                            maxPrice: _maxPrice,
                            onChanged: (value) => setState(() => _maxPrice = value),
                          ),
                          const SizedBox(height: 16),
                          CategoryFilterSection(
                            categories: _categories,
                            selectedCategoryId: _categoryId,
                            onCategoryTap: _toggleCategory,
                            availableSubcategories: _availableSubcategories,
                            selectedSubcategory: _subcategory,
                            onSubcategoryTap: _toggleSubcategory,
                          ),
                          const SizedBox(height: 16),
                          ColorFilterSection(selectedColors: _colors, onColorTap: _toggleColor),
                          const SizedBox(height: 24),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brand.accent,
                      foregroundColor: brand.onAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(
                      SearchFilters(
                        categoryId: _categoryId,
                        subcategory: _subcategory,
                        maxPrice: _maxPrice,
                        colors: _colors,
                      ),
                    ),
                    child: Text(
                      strings.apply,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
