import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// كارت تقييم واحد — صورة/اسم المستخدم، النجوم، التعليق، والتاريخ.
/// [onEdit]/[onDelete] بيتبعتوا null لو التقييم مش بتاع المستخدم
/// الحالي، فالأزرار بتختفي تلقائيًا.
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({super.key, required this.review, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: brand.surface, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: brand.primaryBackground,
            backgroundImage:
                review.userPhotoUrl != null ? NetworkImage(review.userPhotoUrl!) : null,
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
                        style: TextStyle(fontWeight: FontWeight.bold, color: brand.accent),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(review.rating.round().toString()),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment, style: TextStyle(color: brand.textSecondary, height: 1.4)),
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
