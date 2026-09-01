import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'product_card.dart';

/// صف أفقي قابل للتمرير من كروت المنتجات — بيستخدم نفس ProductCard
/// اللي في الشبكة العادية، بس داخل ListView أفقي بعرض ثابت لكل كارت.
class ProductRow extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity>? onProductTap;
  final int? discountPercent;

  const ProductRow({
    super.key,
    required this.products,
    this.onProductTap,
    this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: ProductCard(
              product: product,
              onTap: onProductTap == null ? null : () => onProductTap!(product),
              discountPercent: discountPercent,
            ),
          );
        },
      ),
    );
  }
}
