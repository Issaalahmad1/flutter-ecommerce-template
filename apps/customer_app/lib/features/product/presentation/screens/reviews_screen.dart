import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

/// شاشة كل تقييمات المنتج (بدل الـ 3 اللي بيتعرضوا كمعاينة في صفحة
/// المنتج نفسها) — بتشارك نفس الـ [ProductCubit] بتاع صفحة المنتج
/// (ممرَّر بـ BlocProvider.value)، فأي تعديل بيتضاف من هنا بيظهر
/// فورًا في الصفحتين من غير أي إعادة تحميل يدوي.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
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
          final reviews = state.reviews;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  strings.reviewsCount(reviews.length),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: brand.textSecondary),
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
                          return _ReviewCard(
                            review: review,
                            onEdit: isOwner
                                ? () => _openWriteReviewSheet(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openWriteReviewSheet(context),
        icon: const Icon(Icons.rate_review_outlined),
        label: Text(strings.writeReview),
      ),
    );
  }

  void _openWriteReviewSheet(
    BuildContext context, {
    ReviewEntity? existingReview,
  }) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.signInToReview)),
      );
      return;
    }

    final productCubit = context.read<ProductCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: productCubit,
        child: _WriteReviewSheet(user: authState.user, existingReview: existingReview),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.reviewDeleted)),
                );
              }
            },
            child: Text(strings.deleteReview, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ReviewCard({required this.review, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: brand.primaryBackground,
            backgroundImage: review.userPhotoUrl != null
                ? NetworkImage(review.userPhotoUrl!)
                : null,
            child: review.userPhotoUrl == null
                ? Icon(Icons.person, color: brand.textSecondary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        review.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: brand.accent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(review.rating.round().toString()),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  review.comment,
                  style: TextStyle(color: brand.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      DateFormat.yMMMd(
                        Localizations.localeOf(context).languageCode,
                      ).format(review.createdAt),
                      style: TextStyle(color: brand.textSecondary, fontSize: 11),
                    ),
                    if (onEdit != null || onDelete != null) ...[
                      const Spacer(),
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: Text(
                            strings.editReview,
                            style: TextStyle(
                              color: brand.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (onEdit != null && onDelete != null) const SizedBox(width: 12),
                      if (onDelete != null)
                        GestureDetector(
                          onTap: onDelete,
                          child: Text(
                            strings.deleteReview,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WriteReviewSheet extends StatefulWidget {
  final UserEntity user;
  final ReviewEntity? existingReview;

  const _WriteReviewSheet({required this.user, this.existingReview});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  late final _commentController =
      TextEditingController(text: widget.existingReview?.comment ?? '');
  late int _rating = widget.existingReview?.rating.round() ?? 0;
  bool _isSubmitting = false;

  bool get _isEditing => widget.existingReview != null;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit(String productId) async {
    final strings = context.strings;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.pleaseSelectRating)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final cubit = context.read<ProductCubit>();
      if (_isEditing) {
        await cubit.editReview(
          productId,
          reviewId: widget.existingReview!.id,
          rating: _rating.toDouble(),
          comment: _commentController.text.trim(),
        );
      } else {
        await cubit.submitReview(
          productId,
          userId: widget.user.uid,
          userName: widget.user.fullName.trim().isEmpty
              ? widget.user.email
              : widget.user.fullName,
          userPhotoUrl: widget.user.photoUrl,
          rating: _rating.toDouble(),
          comment: _commentController.text.trim(),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? strings.reviewUpdated : strings.reviewSubmitted)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final productState = context.watch<ProductCubit>().state;
    final productId = productState is ProductLoaded ? productState.product.id : null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing ? strings.editReview : strings.writeReview,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(strings.yourRating, style: TextStyle(color: brand.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = starIndex),
                icon: Icon(
                  starIndex <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: InputDecoration(hintText: strings.reviewCommentHint),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting || productId == null
                  ? null
                  : () => _submit(productId),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(strings.submitReview),
            ),
          ),
        ],
      ),
    );
  }
}
