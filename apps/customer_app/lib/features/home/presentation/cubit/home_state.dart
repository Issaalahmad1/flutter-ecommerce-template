import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> featuredProducts;
  final List<BannerEntity> banners;

  const HomeLoaded({
    required this.categories,
    required this.featuredProducts,
    required this.banners,
  });

  @override
  List<Object?> get props => [categories, featuredProducts, banners];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}