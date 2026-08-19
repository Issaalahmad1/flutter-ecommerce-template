import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final CategoryEntity category;
  final List<ProductEntity> products;
  final String? selectedSubcategory;

  const CategoryLoaded({
    required this.category,
    required this.products,
    this.selectedSubcategory,
  });

  @override
  List<Object?> get props => [category, products, selectedSubcategory];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}