import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// السعر (مع خصم لو فيه عرض نشط) على الشمال، والتقييم على اليمين.
class ProductPriceRow extends StatelessWidget {
  final ProductEntity product;
  final int? discountPercent;

  const ProductPriceRow({super.key, required this.product, this.discountPercent});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discountPercent != null && discountPercent! > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        hasDiscount
            ? _DiscountedPrice(product: product, discountPercent: discountPercent!)
            : _PlainPrice(product: product),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text('${product.rating} (${product.reviewCount})'),
          ],
        ),
      ],
    );
  }
}

class _PlainPrice extends StatelessWidget {
  final ProductEntity product;

  const _PlainPrice({required this.product});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    return Text(
      '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
      style: TextStyle(color: brand.accent, fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}

class _DiscountedPrice extends StatelessWidget {
  final ProductEntity product;
  final int discountPercent;

  const _DiscountedPrice({required this.product, required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${brand.currencySymbol} ${DiscountCalculator.applyDiscount(product.price, discountPercent).toStringAsFixed(2)}',
          style: TextStyle(color: brand.accent, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            color: brand.textSecondary,
            fontSize: 14,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
          child: Text(
            '-$discountPercent%',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
