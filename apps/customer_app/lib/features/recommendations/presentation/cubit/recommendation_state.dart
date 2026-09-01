import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

class RecommendationLoaded extends RecommendationState {
  final List<ProductEntity> products;

  const RecommendationLoaded(this.products);

  @override
  List<Object?> get props => [products];
}
