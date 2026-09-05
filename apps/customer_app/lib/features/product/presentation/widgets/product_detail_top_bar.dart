import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favourite/presentation/cubit/favourite_cubit.dart';
import '../../../favourite/presentation/cubit/favourite_state.dart';

/// زر رجوع + زر تفضيل عائم فوق صورة المنتج مباشرة.
class ProductDetailTopBar extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailTopBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          BlocBuilder<FavouriteCubit, FavouriteState>(
            builder: (context, favState) {
              final isFav = favState is FavouriteLoaded && favState.isFavorite(product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () =>
                    context.read<FavouriteCubit>().toggleFavorite(product.id, product: product),
              );
            },
          ),
        ],
      ),
    );
  }
}
