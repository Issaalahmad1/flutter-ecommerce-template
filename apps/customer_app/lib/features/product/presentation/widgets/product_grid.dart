import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'product_card.dart';

/// شبكة منتجات بعمودين — Wrapper بسيط حوالين GridView.builder
/// بيستخدم ProductCard لكل عنصر.
class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity>? onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
        );
      },
    );
  }
}