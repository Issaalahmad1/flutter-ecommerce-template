import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;

  const ProductsLoaded({required this.products, required this.categories});

  @override
  List<Object?> get props => [products, categories];
}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}