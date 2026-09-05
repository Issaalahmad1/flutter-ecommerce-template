import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_summary.dart';
import '../widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(title: Text(strings.cartTitle)),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return switch (state) {
            CartInitial() || CartLoading() => const Center(child: CircularProgressIndicator()),
            CartError(:final message) => Center(child: Text(message)),
            CartLoaded(:final items) when items.isEmpty => Center(
              child: Text(strings.emptyCart, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            CartLoaded(:final items) => ResponsiveContent(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => CartTile(line: items[index]),
                    ),
                  ),
                  CartSummary(state: state),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
