import 'package:flutter/material.dart';

/// دائرة لون واحدة قابلة للاختيار — لو [color] كان null، دي خيار
/// "بدون لون" (زي X)، مفيدة للمنتجات اللي مالهاش لون محدد.
class ProductColorSwatch extends StatelessWidget {
  final Color? color;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductColorSwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: label ?? 'بدون لون',
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.lightGreenAccent : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: color == null ? const Icon(Icons.close, size: 16, color: Colors.white54) : null,
        ),
      ),
    );
  }
}
