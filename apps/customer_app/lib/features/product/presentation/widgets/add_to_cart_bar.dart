import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/cubit/cart_cubit.dart';

/// شريط سفلي ثابت فيه زرار "أضف إلى السلة" بس — منفصل عشان يوصل
/// دايمًا للمنتج المحمّل حاليًا من غير ما يعرف حاجة عن باقي الشاشة.
class AddToCartBar extends StatelessWidget {
  final ProductEntity product;

  const AddToCartBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {
            await context.read<CartCubit>().addToCart(product.id, product: product);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.strings.addedToCart)),
              );
            }
          },
          child: Text(context.strings.addToCart),
        ),
      ),
    );
  }
}
