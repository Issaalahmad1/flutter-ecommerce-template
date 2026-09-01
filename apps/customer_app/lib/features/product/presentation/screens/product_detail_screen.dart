import 'package:cached_network_image/cached_network_image.dart';

import 'package:customer_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:customer_app/features/favourite/presentation/cubit/favourite_state.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              ProductLoaded(
                :final product,
                :final reviews,
                :final discountPercent,
              ) =>
                Column(
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
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : null,
                                ),
                                onPressed: () => context
                                    .read<FavouriteCubit>()
                                    .toggleFavorite(product.id, product: product),
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
                            _ProductGallery(images: product.images),
                            const SizedBox(height: 20),
                            _TranslatableProductInfo(product: product),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                discountPercent != null && discountPercent > 0
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${brand.currencySymbol} ${DiscountCalculator.applyDiscount(product.price, discountPercent).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: brand.accent,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${brand.currencySymbol} ${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: brand.textSecondary,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '-$discountPercent%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
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
                                  context.strings.userReviews,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  context.strings.reviewsCount(reviews.length),
                                  style: TextStyle(color: brand.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (reviews.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  context.strings.noReviewsYet,
                                  style: TextStyle(color: brand.textSecondary),
                                ),
                              )
                            else
                              ...reviews
                                  .take(3)
                                  .map(
                                    (review) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
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
                  await context.read<CartCubit>().addToCart(
                        state.product.id,
                        product: state.product,
                      );

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
        },
      ),
    );
  }
}



class _ProductGallery extends StatefulWidget {
  final List<String> images;

  const _ProductGallery({required this.images});

  @override
  State<_ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<_ProductGallery> {
  final _pageController = PageController();
  int _activeIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToImage(int index) {
    setState(() => _activeIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    if (widget.images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: brand.surface,
            child: Icon(Icons.image_outlined, size: 60, color: brand.textSecondary),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _activeIndex = index),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isActive = index == _activeIndex;
                return GestureDetector(
                  onTap: () => _goToImage(index),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive ? brand.accent : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// اسم ووصف المنتج + رابط "ترجمة" واحد تحتهم لو لغة المحتوى مختلفة عن
/// لغة التطبيق الحالية — بالظبط نفس فكرة "See translation" في
/// إنستجرام: مفيش ترجمة مقدّمًا، بس أول ضغطة بتترجم الاسم والوصف
/// مع بعض وبتتحفظ في المنتج نفسه عشان أي حد تاني ياخدها جاهزة من
/// غير ما نطلب من الذكاء الاصطناعي تاني.
class _TranslatableProductInfo extends StatefulWidget {
  final ProductEntity product;

  const _TranslatableProductInfo({required this.product});

  @override
  State<_TranslatableProductInfo> createState() => _TranslatableProductInfoState();
}

class _TranslatableProductInfoState extends State<_TranslatableProductInfo> {
  String? _translatedName;
  String? _translatedDescription;
  bool _showingTranslation = false;
  bool _isTranslating = false;

  bool get _shouldOfferTranslation {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabicText = ProductTranslationService.looksArabic(widget.product.name) ||
        ProductTranslationService.looksArabic(widget.product.description);
    return (locale == 'ar' && !isArabicText) || (locale == 'en' && isArabicText);
  }

  Future<void> _toggleTranslation() async {
    if (_showingTranslation) {
      setState(() => _showingTranslation = false);
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final cachedName = locale == 'ar' ? widget.product.nameAr : widget.product.nameEn;
    final cachedDescription =
        locale == 'ar' ? widget.product.descriptionAr : widget.product.descriptionEn;
    if (cachedName != null && cachedDescription != null) {
      setState(() {
        _translatedName = cachedName;
        _translatedDescription = cachedDescription;
        _showingTranslation = true;
      });
      return;
    }

    setState(() => _isTranslating = true);
    try {
      final targetLanguageName = locale == 'ar' ? 'Arabic' : 'English';
      final service = ProductTranslationService();
      final results = await Future.wait([
        service.translate(widget.product.name, targetLanguageName: targetLanguageName),
        service.translate(widget.product.description, targetLanguageName: targetLanguageName),
      ]);
      if (!mounted) return;
      setState(() {
        _translatedName = results[0];
        _translatedDescription = results[1];
        _showingTranslation = true;
        _isTranslating = false;
      });
      final updated = locale == 'ar'
          ? widget.product.copyWith(nameAr: results[0], descriptionAr: results[1])
          : widget.product.copyWith(nameEn: results[0], descriptionEn: results[1]);
      // مش محتاجين ننتظر الحفظ — العرض للمستخدم الحالي خلص أصلاً.
      ProductRepositoryImpl().updateProduct(updated);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showingTranslation && _translatedName != null
              ? _translatedName!
              : widget.product.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          _showingTranslation && _translatedDescription != null
              ? _translatedDescription!
              : widget.product.description,
          style: TextStyle(color: brand.textSecondary, height: 1.5),
        ),
        if (_shouldOfferTranslation || _showingTranslation) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _isTranslating ? null : _toggleTranslation,
            child: Text(
              _isTranslating
                  ? strings.translating
                  : (_showingTranslation ? strings.showOriginal : strings.seeTranslation),
              style: TextStyle(
                color: brand.accent,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: brand.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}