import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/category_form_dialog.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoriesCubit(categoryRepository: CategoryRepositoryImpl())
            ..loadCategories(),
      child: const _CategoriesScreenBody(),
    );
  }
}

class _CategoriesScreenBody extends StatelessWidget {
  const _CategoriesScreenBody();

  void _openForm(
    BuildContext context,
    List<CategoryEntity> allCategories, {
    CategoryEntity? category,
  }) {
    final cubit = context.read<CategoriesCubit>();
    showDialog(
      context: context,
      builder: (_) => CategoryFormDialog(
        category: category,
        allCategories: allCategories,
        onSubmit: (result, {required bool isNew}) async {
          if (isNew) {
            await cubit.createCategory(result);
          } else {
            await cubit.updateCategory(result);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryEntity category) {
    final cubit = context.read<CategoriesCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف "${category.name}"؟'),
        content: const Text(
          'تحذير: لو فيه منتجات مرتبطة بالفئة دي، هتفضل موجودة لكن من غير فئة صحيحة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deleteCategory(category.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return switch (state) {
          CategoriesInitial() || CategoriesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CategoriesError(:final message) => Center(child: Text(message)),
          CategoriesLoaded(:final categories) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 44),
                      ),
                      onPressed: () => _openForm(context, categories),
                      icon: const Icon(Icons.add),
                      label: const Text('Add category'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: categories.map((category) {
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: brand.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () => _openForm(
                                  context,
                                  categories,
                                  category: category,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _confirmDelete(context, category),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ID: ${category.id}',
                            style: TextStyle(
                              fontSize: 11,
                              color: brand.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: category.subcategories
                                .map(
                                  (sub) => Chip(
                                    label: Text(
                                      sub,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        };
      },
    );
  }
}
