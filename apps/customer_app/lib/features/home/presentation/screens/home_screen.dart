import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app/features/category/presentation/screens/category_screen.dart';
import 'package:customer_app/features/favourite/presentation/screens/favourite_screen.dart';
import 'package:customer_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:customer_app/features/product/presentation/widgets/product_grid.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerController = PageController();
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHome();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 16),
            Image.asset(brand.logoAssetPath, height: 30),
          ],
        ),
        title: Text(
          brand.appName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: brand.accent),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              // شاشة البحث هنبنيها في خطوة قادمة منفصلة
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavouriteScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() ||
            HomeLoading() => const Center(child: CircularProgressIndicator()),
            HomeError(:final message) => Center(child: Text(message)),
            HomeLoaded(
              :final categories,
              :final featuredProducts,
              :final banners,
            ) =>
              RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().loadHome(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    if (banners.isNotEmpty) ...[
                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          controller: _bannerController,
                          onPageChanged: (index) =>
                              setState(() => _currentBanner = index),
                          itemCount: banners.length,
                          itemBuilder: (context, index) {
                            final banner = banners[index];
                            return GestureDetector(
                              onTap: banner.categoryId == null
                                  ? null
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CategoryScreen(
                                            categoryId: banner.categoryId!,
                                          ),
                                        ),
                                      );
                                    },
                              child: _PromoBanner(
                                discount: banner.discountLabel,
                                title: banner.title,
                                subtitle: banner.subtitle,
                                expiresAt: banner.expiresAt,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(banners.length, (index) {
                          final isActive = _currentBanner == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? brand.accent
                                  : brand.textSecondary.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],

                    _CategoryRow(categories: categories),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Top selling',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductGrid(
                      products: featuredProducts,
                      onProductTap: (product) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String discount;
  final String title;
  final String subtitle;
  final DateTime? expiresAt;

  const _PromoBanner({
    required this.discount,
    required this.title,
    required this.subtitle,
    this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    final daysLeft = expiresAt == null
        ? null
        : expiresAt!.difference(DateTime.now()).inDays + 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$discount off',
                  style: TextStyle(
                    color: brand.accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: brand.textSecondary),
                ),
                if (daysLeft != null && daysLeft > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      daysLeft == 1
                          ? 'ينتهي غدًا'
                          : 'ينتهي خلال $daysLeft أيام',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.weekend_outlined, size: 70, color: brand.textSecondary),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final List<CategoryEntity> categories;
  const _CategoryRow({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryScreen(categoryId: category.id),
                ),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(
                    category.imageUrl,
                  ),
                ),
                const SizedBox(height: 6),
                Text(category.name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
