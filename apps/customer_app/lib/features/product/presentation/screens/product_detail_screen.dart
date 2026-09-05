import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/add_to_cart_bar.dart';
import '../widgets/product_detail_top_bar.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_price_row.dart';
import '../widgets/product_reviews_preview.dart';
import '../widgets/translatable_product_info.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // بيانات "آخر ما شاهدت" لتغذية نظام التوصية — بنسجّلها هنا (مش في
    // ProductCubit) عشان تفضل مسؤولية Cubit المنتج محصورة في عرض
    // تفاصيل المنتج نفسه بس.
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      RecentlyViewedRepositoryImpl().recordView(authState.user.uid, productId);
    }

    return BlocProvider(
      create: (_) => ProductCubit(productRepository: ProductRepositoryImpl())
        ..loadProduct(productId),
      child: const _ProductDetailBody(),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return switch (state) {
              ProductInitial() || ProductLoading() =>
                const Center(child: CircularProgressIndicator()),
              ProductError(:final message) => Center(child: Text(message)),
              ProductLoaded() => _ProductDetailContent(state: state),
            };
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is! ProductLoaded) return const SizedBox.shrink();
          return AddToCartBar(product: state.product);
        },
      ),
    );
  }
}

/// جسم الصفحة بعد ما المنتج يتحمّل — المحتوى متمركز وبعرض أقصى على
/// الشاشات العريضة جدًا (تابلت بالوضع الأفقي) عشان النصوص متمطّطش.
class _ProductDetailContent extends StatelessWidget {
  final ProductLoaded state;

  const _ProductDetailContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final product = state.product;

    return Column(
      children: [
        ProductDetailTopBar(product: product),
        Expanded(
          child: SingleChildScrollView(
            child: ResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductGallery(images: product.images),
                    const SizedBox(height: 20),
                    TranslatableProductInfo(product: product),
                    const SizedBox(height: 16),
                    ProductPriceRow(product: product, discountPercent: state.discountPercent),
                    const Divider(height: 32),
                    ProductReviewsPreview(reviews: state.reviews),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
