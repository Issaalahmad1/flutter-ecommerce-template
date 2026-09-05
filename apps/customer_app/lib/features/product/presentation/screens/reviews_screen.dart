import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/review_card.dart';
import '../widgets/write_review_sheet.dart';

/// شاشة كل تقييمات المنتج (بدل الـ 3 اللي بيتعرضوا كمعاينة في صفحة
/// المنتج نفسها) — بتشارك نفس الـ [ProductCubit] بتاع صفحة المنتج
/// (ممرَّر بـ BlocProvider.value)، فأي تعديل بيتضاف من هنا بيظهر
/// فورًا في الصفحتين من غير أي إعادة تحميل يدوي.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final currentUserId = context.select<AuthCubit, String?>((cubit) {
      final state = cubit.state;
      return state is AuthAuthenticated ? state.user.uid : null;
    });

    return Scaffold(
      appBar: AppBar(title: Text(strings.userReviews), centerTitle: true),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is! ProductLoaded) return const SizedBox.shrink();
          return _ReviewsList(state: state, currentUserId: currentUserId);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openWriteReviewSheet(context),
        icon: const Icon(Icons.rate_review_outlined),
        label: Text(strings.writeReview),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  final ProductLoaded state;
  final String? currentUserId;

  const _ReviewsList({required this.state, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final reviews = state.reviews;

    return ResponsiveContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              strings.reviewsCount(reviews.length),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: brand.textSecondary),
            ),
          ),
          Expanded(
            child: reviews.isEmpty
                ? Center(
                    child: Text(
                      strings.noReviewsYet,
                      style: TextStyle(color: brand.textSecondary),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: reviews.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final isOwner = review.userId == currentUserId;
                      return ReviewCard(
                        review: review,
                        onEdit: isOwner
                            ? () => openWriteReviewSheet(
                                context,
                                existingReview: review,
                              )
                            : null,
                        onDelete: isOwner
                            ? () => _confirmDelete(
                                context,
                                state.product.id,
                                review.id,
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId, String reviewId) {
    final strings = context.strings;
    final productCubit = context.read<ProductCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.confirmDeleteReview),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await productCubit.removeReview(productId, reviewId);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(strings.reviewDeleted)));
              }
            },
            child: Text(
              strings.deleteReview,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

void openWriteReviewSheet(
  BuildContext context, {
  ReviewEntity? existingReview,
}) {
  final authState = context.read<AuthCubit>().state;
  if (authState is! AuthAuthenticated) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.strings.signInToReview)));
    return;
  }

  final productCubit = context.read<ProductCubit>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => BlocProvider.value(
      value: productCubit,
      child: WriteReviewSheet(
        user: authState.user,
        existingReview: existingReview,
      ),
    ),
  );
}
