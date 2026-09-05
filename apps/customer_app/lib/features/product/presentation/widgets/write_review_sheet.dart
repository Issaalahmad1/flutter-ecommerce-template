import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

/// نموذج إضافة/تعديل تقييم — بيتفتح كـ bottom sheet. لو [existingReview]
/// موجود بنكون في وضع التعديل (الحقول متعبّية بالقيم الحالية).
class WriteReviewSheet extends StatefulWidget {
  final UserEntity user;
  final ReviewEntity? existingReview;

  const WriteReviewSheet({super.key, required this.user, this.existingReview});

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
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
          userName:
              widget.user.fullName.trim().isEmpty ? widget.user.email : widget.user.fullName,
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
              onPressed: _isSubmitting || productId == null ? null : () => _submit(productId),
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
