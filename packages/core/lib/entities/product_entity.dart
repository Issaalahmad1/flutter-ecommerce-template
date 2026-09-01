import 'package:equatable/equatable.dart';

enum ProductStatus { active, draft, outOfStock }

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final String? subcategoryId;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFeatured;
  final ProductStatus status;
  final DateTime createdAt;

  /// لون المنتج (Hex زي '#8B5CF6') — اختياري، مش كل منتج لازم يكون
  /// ليه لون محدد (زي سجادة متعددة الألوان مثلاً).
  final String? color;

  /// ترجمات الوصف المخزّنة (Cache) — بتتحسب مرة واحدة بس أول ما حد
  /// يدوس "ترجمة"، وبعدين بتتحفظ هنا عشان أي مستخدم تاني يستفيد منها
  /// من غير ما نطلب من الذكاء الاصطناعي يترجم نفس النص تاني.
  final String? descriptionAr;
  final String? descriptionEn;
  final String? nameAr;
  final String? nameEn;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categoryId,
    this.subcategoryId,
    this.rating = 0,
    this.reviewCount = 0,
    required this.stock,
    this.isFeatured = false,
    this.status = ProductStatus.active,
    required this.createdAt,
    this.color,
    this.descriptionAr,
    this.descriptionEn,
    this.nameAr,
    this.nameEn,
  });

  String get thumbnail => images.isNotEmpty ? images.first : '';

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? images,
    String? categoryId,
    String? subcategoryId,
    double? rating,
    int? reviewCount,
    int? stock,
    bool? isFeatured,
    ProductStatus? status,
    DateTime? createdAt,
    String? color,
    bool clearColor = false,
    String? descriptionAr,
    String? descriptionEn,
    String? nameAr,
    String? nameEn,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      color: clearColor ? null : (color ?? this.color),
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
    );
  }

  factory ProductEntity.fromJson(String id, Map<String, dynamic> json) {
    return ProductEntity(
      id: id,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: List<String>.from(json['images'] as List? ?? const []),
      categoryId: json['categoryId'] as String? ?? '',
      subcategoryId: json['subcategoryId'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      status: ProductStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      color: json['color'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'isFeatured': isFeatured,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'color': color,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        images,
        categoryId,
        subcategoryId,
        rating,
        reviewCount,
        stock,
        isFeatured,
        status,
        createdAt,
        color,
        descriptionAr,
        descriptionEn,
        nameAr,
        nameEn,
      ];
}
