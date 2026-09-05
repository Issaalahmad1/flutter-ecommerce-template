import 'package:customer_app/features/category/presentation/screens/category_screen.dart';
import 'package:customer_app/shared/category_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class HomeCategoryRow extends StatelessWidget {
  final List<CategoryEntity> categories;
  const HomeCategoryRow({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
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
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: brand.surface,
                  child: ClipOval(
                    child: CategoryImage(
                      imageUrl: category.imageUrl,
                      fit: BoxFit.contain,
                      size: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(category.name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
