import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String discountLabel;
  final String? imageUrl;
  final String? categoryId;
  final int order;
  final bool isActive;
  final DateTime? expiresAt;
  final DateTime createdAt;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discountLabel,
    this.imageUrl,
    this.categoryId,
    this.order = 0,
    this.isActive = true,
    this.expiresAt,
    required this.createdAt,
  });

  factory BannerEntity.fromJson(String id, Map<String, dynamic> json) {
    return BannerEntity(
      id: id,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      discountLabel: json['discountLabel'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.tryParse(json['expiresAt'] as String),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'discountLabel': discountLabel,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (categoryId != null) 'categoryId': categoryId,
      'order': order,
      'isActive': isActive,
      if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
  /// نسخة رقمية من discountLabel — نافعة لحساب الخصم الفعلي.
/// لو discountLabel مش رقم صحيح لأي سبب (بيانات قديمة مثلاً)، بترجع null.
int? get discountPercent => int.tryParse(discountLabel);
  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        discountLabel,
        imageUrl,
        categoryId,
        order,
        isActive,
        expiresAt,
        createdAt,
      ];
}