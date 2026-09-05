import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// عنصر صورة واحد في المعرض — إما رابط قديم موجود بالفعل، أو بايتات
/// صورة جديدة لسه في الذاكرة. الترتيب في القايمة بتاعة الفورم هو
/// اللي بيحدد "مين الأساسية" (أول عنصر دايمًا).
class ProductFormImage {
  final String? existingUrl;
  final Uint8List? bytes;

  ProductFormImage.existing(this.existingUrl) : bytes = null;
  ProductFormImage.picked(this.bytes) : existingUrl = null;

  ImageProvider get provider =>
      bytes != null ? MemoryImage(bytes!) : NetworkImage(existingUrl!) as ImageProvider;
}
