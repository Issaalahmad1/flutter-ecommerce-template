import 'package:equatable/equatable.dart';

/// سلايد واحد في شاشة الـ Onboarding (بعد شاشة الترحيب) — قابل
/// للإدارة بالكامل من لوحة تحكم الأدمن (صورة + نص عربي/إنجليزي)،
/// عكس بقية شاشات الـ Auth اللي نصوصها ثابتة في الكود.
class OnboardingSlideEntity extends Equatable {
  final String id;
  final String? imageUrl;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final int order;
  final DateTime createdAt;

  const OnboardingSlideEntity({
    required this.id,
    this.imageUrl,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.order = 0,
    required this.createdAt,
  });

  String title(String languageCode) => languageCode == 'ar' ? titleAr : titleEn;
  String description(String languageCode) =>
      languageCode == 'ar' ? descriptionAr : descriptionEn;

  factory OnboardingSlideEntity.fromJson(String id, Map<String, dynamic> json) {
    return OnboardingSlideEntity(
      id: id,
      imageUrl: json['imageUrl'] as String?,
      titleAr: json['titleAr'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (imageUrl != null) 'imageUrl': imageUrl,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    imageUrl,
    titleAr,
    titleEn,
    descriptionAr,
    descriptionEn,
    order,
    createdAt,
  ];
}
