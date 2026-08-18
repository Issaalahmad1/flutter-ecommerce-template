import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final int order;
  final List<String> subcategories;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.order = 0,
    this.subcategories = const [],
  });

  factory CategoryEntity.fromJson(String id, Map<String, dynamic> json) {
    return CategoryEntity(
      id: id,
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      subcategories: List<String>.from(json['subcategories'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': imageUrl,
      'order': order,
      'subcategories': subcategories,
    };
  }

  @override
  List<Object?> get props => [id, name, imageUrl, order, subcategories];
}
