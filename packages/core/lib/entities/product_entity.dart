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
      ];
}
