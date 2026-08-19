import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// كارت منتج واحد — بيتكرر في Home وCategory وSearch وSpecial Offer
/// (راجع قسم 03 في الدليل). أي تعديل بصري على شكل الكارت، مكانه هنا بس.
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: brand.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.rating > 0)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}