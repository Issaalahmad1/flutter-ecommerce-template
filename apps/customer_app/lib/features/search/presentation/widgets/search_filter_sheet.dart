import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../cubit/search_state.dart';

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
                          _SectionTitle(strings.priceRange, brand: brand),
                          Slider(
                            value: _maxPrice,
                            min: 0,
                            max: 1500,
                            divisions: 15,
                            activeColor: brand.accent,
                            label: '${brand.currencySymbol}${_maxPrice.round()}',
                            onChanged: (value) => setState(() => _maxPrice = value),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${brand.currencySymbol}0',
                                    style: TextStyle(color: brand.textSecondary)),
                                Text(
                                  '${strings.upTo} ${brand.currencySymbol}${_maxPrice.round()}',
                                  style: TextStyle(color: brand.accent, fontWeight: FontWeight.bold),
                                ),
                                Text('${brand.currencySymbol}1500',
                                    style: TextStyle(color: brand.textSecondary)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(strings.filterCategories, brand: brand),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final category in _categories)
                                _FilterChip(
                                  label: category.name,
                                  isSelected: _categoryId == category.id,
                                  brand: brand,
                                  onTap: () => setState(() {
                                    _categoryId =
                                        _categoryId == category.id ? null : category.id;
                                    if (!_availableSubcategories.contains(_subcategory)) {
                                      _subcategory = null;
                                    }
                                  }),
                                ),
                            ],
                          ),
                          if (_availableSubcategories.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _SectionTitle(strings.filterProducts, brand: brand),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final sub in _availableSubcategories)
                                  _FilterChip(
                                    label: sub,
                                    isSelected: _subcategory == sub,
                                    brand: brand,
                                    onTap: () => setState(
                                      () => _subcategory = _subcategory == sub ? null : sub,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          _SectionTitle(strings.filterColors, brand: brand),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final entry in ProductColorPalette.colors.entries)
                                _ColorSwatch(
                                  color: ProductColorPalette.toColor(entry.value),
                                  isSelected: _colors.contains(entry.value),
                                  brand: brand,
                                  onTap: () => setState(() {
                                    if (_colors.contains(entry.value)) {
                                      _colors.remove(entry.value);
                                    } else {
                                      _colors.add(entry.value);
                                    }
                                  }),
                                ),
                            ],
                          ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  final BrandConfig brand;

  const _SectionTitle(this.text, {required this.brand});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: brand.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final BrandConfig brand;
  final VoidCallback onTap;

  const _FilterChip({
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

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final BrandConfig brand;
  final VoidCallback onTap;

  const _ColorSwatch({
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
          border: Border.all(
            color: isSelected ? brand.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
