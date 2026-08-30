import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// بتعرض صورة الفئة بغض النظر عن مصدرها — أيقونة SVG محلية من
/// مكتبة الأيقونات الجاهزة، أو صورة حقيقية مرفوعة من الأدمن عبر
/// رابط شبكة. الشاشات مش محتاجة تعرف الفرق، بس تستخدم الـ Widget ده.
class CategoryImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final BoxFit fit;

  const CategoryImage({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (CategoryIconLibrary.isLocalIcon(imageUrl)) {
      return SvgPicture.asset(
        imageUrl,
        width: size,
        height: size,
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: fit,
    );
  }
}