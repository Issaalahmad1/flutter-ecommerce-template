import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final ProductEntity product;
  final List<ReviewEntity> reviews;
  final int? discountPercent;

  const ProductLoaded({
    required this.product,
    required this.reviews,
    this.discountPercent,
  });

  @override
  List<Object?> get props => [product, reviews, discountPercent];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
