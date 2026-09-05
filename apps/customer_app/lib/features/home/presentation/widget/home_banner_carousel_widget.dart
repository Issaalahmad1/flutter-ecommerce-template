import 'package:customer_app/features/category/presentation/screens/category_screen.dart';
import 'package:customer_app/features/home/presentation/widget/home_promo_banner.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class HomeBannerCarouselWidget extends StatefulWidget {
  final PageController _bannerController;

  final List<BannerEntity> banners;
  final BrandConfig brand;
  const HomeBannerCarouselWidget({
    super.key,
    required this._bannerController,
    required this.banners,
    required this.brand,
  });

  @override
  State<HomeBannerCarouselWidget> createState() =>
      _HomeBannerCarouselWidgetState();
}

class _HomeBannerCarouselWidgetState extends State<HomeBannerCarouselWidget> {
  int _currentBanner = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: widget._bannerController,
            onPageChanged: (index) => setState(() => _currentBanner = index),
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return GestureDetector(
                onTap: banner.categoryId == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryScreen(categoryId: banner.categoryId!),
                          ),
                        );
                      },
                child: HomePromoBanner(
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
          children: List.generate(widget.banners.length, (index) {
            final isActive = _currentBanner == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? widget.brand.accent
                    : widget.brand.textSecondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
