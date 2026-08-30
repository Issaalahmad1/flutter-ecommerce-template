import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_state.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// كارت منتج واحد — بيتكرر في Home وCategory وSearch وSpecial Offer
/// (راجع قسم 03 في الدليل). أي تعديل بصري على شكل الكارت، مكانه هنا بس.
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final int? discountPercent;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.discountPercent,
  });

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
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: BlocBuilder<FavouriteCubit, FavouriteState>(
                    builder: (context, state) {
                      final isFav =
                          state is FavouriteLoaded &&
                          state.isFavorite(product.id);
                      return GestureDetector(
                        onTap: () => context
                            .read<FavouriteCubit>()
                            .toggleFavorite(product.id),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                      Expanded(
                        child: discountPercent != null && discountPercent! > 0
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${brand.currencySymbol} ${DiscountCalculator.applyDiscount(product.price, discountPercent).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: brand.accent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: brand.textSecondary,
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: brand.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating}',
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
