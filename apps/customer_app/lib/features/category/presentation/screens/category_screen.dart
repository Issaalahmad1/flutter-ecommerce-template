import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

/// الغلاف العام — بيوفّر الـ CategoryCubit بنفسه، فمفيش أي حد يستدعيها
/// محتاج يعرف تفاصيل إعدادها. بمجرد ما الـ Cubit يتعمل، بنطلب تحميل
/// الفئة على طول (..loadCategory) قبل ما نعرض أي واجهة.
class CategoryScreen extends StatelessWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(
        categoryRepository: CategoryRepositoryImpl(),
        productRepository: ProductRepositoryImpl(),
      )..loadCategory(categoryId),
      child: const _CategoryScreenBody(),
    );
  }
}

class _CategoryScreenBody extends StatelessWidget {
  const _CategoryScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            return switch (state) {
              CategoryInitial() || CategoryLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              CategoryError(:final message) => Center(child: Text(message)),
              CategoryLoaded(
                :final category,
                :final products,
                :final selectedSubcategory,
                :final discountPercent,
              ) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _SubcategoryChip(
                            label: 'All',
                            isSelected: selectedSubcategory == null,
                            onTap: () => context
                                .read<CategoryCubit>()
                                .filterBySubcategory(null),
                          ),
                          const SizedBox(width: 8),
                          ...category.subcategories.map(
                            (sub) => Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _SubcategoryChip(
                                label: sub,
                                isSelected: selectedSubcategory == sub,
                                onTap: () => context
                                    .read<CategoryCubit>()
                                    .filterBySubcategory(sub),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: products.isEmpty
                          ? const Center(
                              child: Text('لا توجد منتجات في هذا القسم.'),
                            )
                          : SingleChildScrollView(
                              child: ProductGrid(
                                products: products,
                                  discountPercent: discountPercent,

                                onProductTap: (product) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        productId: product.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}

class _SubcategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubcategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: brand.accent,
      labelStyle: TextStyle(
        color: isSelected ? brand.onAccent : brand.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: brand.surface,
    );
  }
}
