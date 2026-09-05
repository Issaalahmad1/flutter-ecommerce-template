import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';
import '../screens/reviews_screen.dart';

/// أول 3 تقييمات بس + رابط "عرض الكل" ياخد لصفحة كل التقييمات
/// (ReviewsScreen) — دي معاينة سريعة جوه صفحة المنتج نفسها.
class ProductReviewsPreview extends StatelessWidget {
  final List<ReviewEntity> reviews;

  const ProductReviewsPreview({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.userReviews, style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Text(
                  strings.reviewsCount(reviews.length),
                  style: TextStyle(color: brand.textSecondary),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ProductCubit>(),
                        child: const ReviewsScreen(),
                      ),
                    ),
                  ),
                  child: Text(
                    strings.seeAll,
                    style: TextStyle(color: brand.accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(strings.noReviewsYet, style: TextStyle(color: brand.textSecondary)),
          )
        else
          ...reviews.take(3).map((review) => _ReviewPreviewTile(review: review)),
      ],
    );
  }
}

class _ReviewPreviewTile extends StatelessWidget {
  final ReviewEntity review;

  const _ReviewPreviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round() ? Icons.star : Icons.star_border,
                    size: 14,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.comment, style: TextStyle(color: brand.textSecondary)),
        ],
      ),
    );
  }
}
