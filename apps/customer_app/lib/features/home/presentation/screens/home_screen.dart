import 'package:customer_app/features/home/presentation/widget/home_appbar_widget.dart';
import 'package:customer_app/features/home/presentation/widget/home_banner_carousel_widget.dart';
import 'package:customer_app/features/home/presentation/widget/home_category_row.dart';
import 'package:customer_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:customer_app/features/product/presentation/widgets/product_grid.dart';
import 'package:customer_app/features/product/presentation/widgets/product_row.dart';
import 'package:customer_app/features/recommendations/presentation/cubit/recommendation_cubit.dart';
import 'package:customer_app/features/recommendations/presentation/cubit/recommendation_state.dart';
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
      appBar: HomeAppbarWidget(brand: brand),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() ||
            HomeLoading() => const Center(child: CircularProgressIndicator()),
            HomeError(:final message) => Center(child: Text(message)),
            HomeLoaded(:final categories, :final allProducts, :final banners) =>
              RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().loadHome(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: <Widget>[
                    if (banners.isNotEmpty) ...[
                      HomeBannerCarouselWidget(
                        bannerController: _bannerController,
                        banners: banners,
                        brand: brand,
                      ),
                    ],

                    HomeCategoryRow(categories: categories),
                    const SizedBox(height: 24),
                    BlocBuilder<RecommendationCubit, RecommendationState>(
                      builder: (context, recState) {
                        if (recState is! RecommendationLoaded ||
                            recState.products.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                context.strings.recommendedForYou,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ProductRow(
                              products: recState.products,
                              onProductTap: (product) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.strings.topSelling,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductRow(
                      products: state.topSellingProducts,
                      onProductTap: (product) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.strings.topRated,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductRow(
                      products: state.topRatedProducts,
                      onProductTap: (product) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.strings.discover,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductGrid(
                      products: allProducts,
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
