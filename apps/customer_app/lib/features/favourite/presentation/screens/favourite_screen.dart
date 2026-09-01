import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../cubit/favourite_cubit.dart';
import '../cubit/favourite_state.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(title: Text(strings.favouriteTitle)),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state is! FavouriteLoaded || state.products.isEmpty) {
            return Center(
              child: Text(
                strings.emptyFavourites,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ProductGrid(
              products: state.products,
              onProductTap: (product) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(productId: product.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}