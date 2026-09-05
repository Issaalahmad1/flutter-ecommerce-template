import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

/// صف منتج واحد في السلة — صورة، اسم، سعر (مع خصم لو موجود)، وعداد
/// كمية بيبعت التحديث لـ CartCubit مباشرة.
class CartTile extends StatelessWidget {
  final CartLineItem line;

  const CartTile({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final hasDiscount = line.discountPercent != null && line.discountPercent! > 0;

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
              Text(line.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              hasDiscount
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
              onPressed: () =>
                  context.read<CartCubit>().updateQuantity(line.product.id, line.quantity - 1),
            ),
            Text('${line.quantity}'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: () =>
                  context.read<CartCubit>().updateQuantity(line.product.id, line.quantity + 1),
            ),
          ],
        ),
      ],
    );
  }
}
