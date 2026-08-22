import 'package:cached_network_image/cached_network_image.dart';

import 'package:customer_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_state.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/product_repository_impl.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductCubit(productRepository: ProductRepositoryImpl())
            ..loadProduct(productId),
      child: const _ProductDetailBody(),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody();

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return switch (state) {
              ProductInitial() || ProductLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProductError(:final message) => Center(child: Text(message)),
              ProductLoaded(:final product, :final reviews) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        BlocBuilder<FavouriteCubit, FavouriteState>(
                          builder: (context, favState) {
                            final isFav =
                                favState is FavouriteLoaded &&
                                favState.isFavorite(product.id);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : null,
                              ),
                              onPressed: () => context
                                  .read<FavouriteCubit>()
                                  .toggleFavorite(product.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: product.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: TextStyle(
                              color: brand.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: brand.accent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating} (${product.reviewCount})',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'User Reviews',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${reviews.length}+ Reviews',
                                style: TextStyle(color: brand.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (reviews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'لا توجد تقييمات بعد.',
                                style: TextStyle(color: brand.textSecondary),
                              ),
                            )
                          else
                            ...reviews
                                .take(3)
                                .map(
                                  (review) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              review.userName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (i) => Icon(
                                                  i < review.rating.round()
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  size: 14,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          review.comment,
                                          style: TextStyle(
                                            color: brand.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            };
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is! ProductLoaded) return const SizedBox.shrink();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<CartCubit>().addToCart(state.product.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت الإضافة إلى السلة.')),
                    );
                  }
                },
                child: const Text('Add To Cart'),
              ),
            ),
          );
        },
      ),
    );
  }
}
