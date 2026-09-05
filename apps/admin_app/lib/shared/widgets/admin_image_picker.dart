import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// معاينة صورة عامة + زرار الاختيار — مستخدمة في أي فورم أدمن فيه
/// رفع صورة واحدة (بانر، سلايد onboarding...). بتعرض الصورة المختارة
/// حديثًا لو موجودة، وإلا القديمة، وإلا Placeholder فاضي.
class AdminImagePicker extends StatelessWidget {
  final Uint8List? pickedImageBytes;
  final String? existingImageUrl;
  final VoidCallback onTap;
  final String placeholderLabel;

  const AdminImagePicker({
    super.key,
    required this.pickedImageBytes,
    required this.existingImageUrl,
    required this.onTap,
    this.placeholderLabel = 'اختر صورة',
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedImageBytes != null || existingImageUrl != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          image: pickedImageBytes != null
              ? DecorationImage(image: MemoryImage(pickedImageBytes!), fit: BoxFit.cover)
              : (existingImageUrl != null
                  ? DecorationImage(image: NetworkImage(existingImageUrl!), fit: BoxFit.cover)
                  : null),
        ),
        child: !hasImage
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined, size: 32),
                    const SizedBox(height: 6),
                    Text(placeholderLabel),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'تغيير الصورة',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
      ),
    );
  }
}
