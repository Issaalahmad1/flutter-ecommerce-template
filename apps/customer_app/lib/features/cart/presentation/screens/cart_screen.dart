import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return switch (state) {
            CartInitial() ||
            CartLoading() => const Center(child: CircularProgressIndicator()),
            CartError(:final message) => Center(child: Text(message)),
            CartLoaded(:final items) when items.isEmpty => const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CartLoaded(:final items) => Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final line = items[index];
                      return _CartTile(line: line);
                    },
                  ),
                ),
                _CartSummary(state: state),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartLineItem line;
  const _CartTile({required this.line});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: line.product.thumbnail,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '${brand.currencySymbol} ${line.product.price.toStringAsFixed(2)}',
                style: TextStyle(color: brand.accent),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              onPressed: () => context.read<CartCubit>().updateQuantity(
                line.product.id,
                line.quantity - 1,
              ),
            ),
            Text('${line.quantity}'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () => context.read<CartCubit>().updateQuantity(
                line.product.id,
                line.quantity + 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartLoaded state;
  const _CartSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: state.subtotal),
          _SummaryRow(label: 'Tax and Fees', value: state.tax),
          _SummaryRow(label: 'Delivery', value: state.delivery),
          const Divider(height: 24),
          _SummaryRow(label: 'Total', value: state.total, isBold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // هيتفعّل في خطوة الـ Checkout الجاية.
            },
            child: const Text('Check Out'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
      color: isBold ? brand.accent : brand.textSecondary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${brand.currencySymbol}${value.toStringAsFixed(2)}',
            style: style,
          ),
        ],
      ),
    );
  }
}
