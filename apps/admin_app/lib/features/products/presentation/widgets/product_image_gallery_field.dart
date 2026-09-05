import 'package:flutter/material.dart';

import 'product_form_image.dart';
import 'product_image_thumbnail.dart';

class ProductImageGalleryField extends StatelessWidget {
  final List<ProductFormImage> images;
  final VoidCallback onPickImages;
  final ValueChanged<int> onRemove;
  final ValueChanged<int> onSetPrimary;

  const ProductImageGalleryField({
    super.key,
    required this.images,
    required this.onPickImages,
    required this.onRemove,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Product images', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 8),
            if (images.isNotEmpty)
              Text(
                '(اضغط على النجمة لتحديد الصورة الأساسية)',
                style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < images.length; i++)
              ProductImageThumbnail(
                image: images[i].provider,
                isPrimary: i == 0,
                onRemove: () => onRemove(i),
                onSetPrimary: () => onSetPrimary(i),
              ),
            GestureDetector(
              onTap: onPickImages,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
