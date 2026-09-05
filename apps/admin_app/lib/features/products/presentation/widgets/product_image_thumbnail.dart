import 'package:flutter/material.dart';

/// صورة مصغّرة واحدة جوّه معرض الفورم — نجمة لتحديدها "أساسية"،
/// وزرار X لحذفها.
class ProductImageThumbnail extends StatelessWidget {
  final ImageProvider image;
  final bool isPrimary;
  final VoidCallback onRemove;
  final VoidCallback onSetPrimary;

  const ProductImageThumbnail({
    super.key,
    required this.image,
    required this.isPrimary,
    required this.onRemove,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: image, fit: BoxFit.cover),
              border: isPrimary ? Border.all(color: Colors.lightGreenAccent, width: 2) : null,
            ),
          ),
          // نجمة تحديد "الأساسية" — تفضل ظاهرة دايمًا، لكن ملونة بس لو
          // دي فعلاً الصورة الأساسية حاليًا.
          Positioned(
            bottom: 2,
            left: 2,
            child: GestureDetector(
              onTap: onSetPrimary,
              child: Icon(
                isPrimary ? Icons.star : Icons.star_border,
                size: 18,
                color: isPrimary ? Colors.lightGreenAccent : Colors.white70,
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
