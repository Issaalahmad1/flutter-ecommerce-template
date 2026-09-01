import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_app/features/category/presentation/screens/category_screen.dart';
import 'package:customer_app/features/favourite/presentation/screens/favourite_screen.dart';
import 'package:customer_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:customer_app/features/product/presentation/widgets/product_grid.dart';
import 'package:customer_app/features/product/presentation/widgets/product_row.dart';
import 'package:customer_app/features/search/presentation/screens/search_screen.dart';
import 'package:customer_app/shared/category_image.dart';
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
        // الشعار + اسم البراند بيتحركوا كوحدة واحدة (يمين في RTL، شمال
        // في LTR)، لكن ترتيبهم الداخلي (شعار الأول، بعدين النص) ثابت
        // زي الإنجليزي دايمًا — مش بينعكس مع تغيير اللغة.
        title: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(brand.logoAssetPath, height: 30),
              const SizedBox(width: 8),
              Text(
                brand.appName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: brand.accent),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
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
              :final allProducts,
              :final banners,
            ) =>
              RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().loadHome(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    if (banners.isNotEmpty) ...[
                      SizedBox(
                        height: 140,
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
                                imageUrl: banner.imageUrl,

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
                        context.strings.topSelling,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProductRow(
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

class _PromoBanner extends StatelessWidget {
  final String discount;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime? expiresAt;

  const _PromoBanner({
    required this.discount,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final daysLeft = expiresAt == null
        ? null
        : expiresAt!.difference(DateTime.now()).inDays + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 32,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          // بالعربي "خصم" بييجي قبل الرقم، وبالإنجليزي
                          // "off" بييجي بعده — بنبني الترتيب يدويًا
                          // حسب اللغة بدل ما نعتمد على انعكاس تلقائي.
                          // خط "خصم" أصغر بكتير من الرقم عشان يفضل جنب
                          // النسبة في نفس السطر من غير ما يكبّر الكارت.
                          children: isArabic
                              ? [
                                  TextSpan(
                                    text: '${strings.offLabel} ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: brand.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$discount%",
                                    style: TextStyle(
                                      color: brand.accent,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                              : [
                                  TextSpan(
                                    text: "$discount%",
                                    style: TextStyle(
                                      color: brand.accent,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${strings.offLabel}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 109,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          title,
                          style: const TextStyle(fontSize: 14),
                        ),
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
                                ? strings.endsTomorrow
                                : strings.endsInDays(daysLeft),
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

                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageUrl != null
                          ? CachedNetworkImage(
                              height: 83,
                              width: 198,
                              imageUrl: imageUrl!,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Icon(
                                Icons.weekend_outlined,
                                size: 60,
                                color: brand.textSecondary,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.weekend_outlined,
                                size: 60,
                                color: brand.textSecondary,
                              ),
                            ),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: brand.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    const brand = BrandConfig.decoze; // تأكد من وجود السطر ده

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
                  backgroundColor: brand.surface,
                  child: ClipOval(
                    child: CategoryImage(
                      imageUrl: category.imageUrl,
                      fit: BoxFit.contain,
                      size: 300,
                    ),
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
