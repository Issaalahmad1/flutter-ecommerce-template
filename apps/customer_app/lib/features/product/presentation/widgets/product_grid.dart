import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'product_card.dart';

/// شبكة منتجات — عدد الأعمدة بيتحدد حسب العرض المتاح فعليًا
/// (Responsive.productGridColumns) بدل عمودين ثابتين، عشان تبان كويسة
/// على تابلت مش بس موبايل.
class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity>? onProductTap;
  final int? discountPercent;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.productGridColumns(constraints.maxWidth),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: onProductTap == null ? null : () => onProductTap!(product),
              discountPercent: discountPercent,
            );
          },
        );
      },
    );
  }
}
