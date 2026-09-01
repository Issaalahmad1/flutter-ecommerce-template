import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

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
            CartInitial() ||
            CartLoading() => const Center(child: CircularProgressIndicator()),
            CartError(:final message) => Center(child: Text(message)),
            CartLoaded(:final items) when items.isEmpty => Center(
              child: Text(
                strings.emptyCart,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
              line.discountPercent != null && line.discountPercent! > 0
                  ? Row(
                      children: [
                        Text(
                          '${brand.currencySymbol} ${line.unitPrice.toStringAsFixed(2)}',
                          style: TextStyle(color: brand.accent),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${brand.currencySymbol} ${line.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: brand.textSecondary,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  : Text(
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
    final strings = context.strings;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: strings.subtotal, value: state.subtotal),
          if (state.totalDiscount > 0)
            _SummaryRow(
              label: strings.discount,
              value: -state.totalDiscount,
              isDiscount: true,
            ),
          _SummaryRow(label: strings.taxAndFees, value: state.tax),
          _SummaryRow(label: strings.delivery, value: state.delivery),
          const Divider(height: 24),
          _SummaryRow(label: strings.total, value: state.total, isBold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CheckoutScreen()));
            },
            child: Text(strings.checkOut),
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
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });
  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
      color: isDiscount
          ? Colors.green
          : (isBold ? brand.accent : brand.textSecondary),
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
