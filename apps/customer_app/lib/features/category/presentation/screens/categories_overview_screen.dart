import 'package:customer_app/shared/category_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/categories_overview_cubit.dart';
import '../cubit/categories_overview_state.dart';
import 'category_screen.dart';

class CategoriesOverviewScreen extends StatelessWidget {
  const CategoriesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoriesOverviewCubit(categoryRepository: CategoryRepositoryImpl())
            ..loadCategories(),
      child: const _CategoriesOverviewBody(),
    );
  }
}

class _CategoriesOverviewBody extends StatelessWidget {
  const _CategoriesOverviewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: BlocBuilder<CategoriesOverviewCubit, CategoriesOverviewState>(
        builder: (context, state) {
          return switch (state) {
            CategoriesOverviewInitial() || CategoriesOverviewLoading() =>
              const Center(child: CircularProgressIndicator()),
            CategoriesOverviewError(:final message) => Center(
              child: Text(message),
            ),
            CategoriesOverviewLoaded(:final categories) => GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(categoryId: category.id),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CategoryImage(
                          imageUrl: category.imageUrl,
                          size: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(blurRadius: 6, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }
}
