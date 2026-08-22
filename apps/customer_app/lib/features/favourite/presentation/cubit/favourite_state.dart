import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object?> get props => [];
}

class FavouriteInitial extends FavouriteState {
  const FavouriteInitial();
}

class FavouriteLoaded extends FavouriteState {
  final List<String> favoriteIds;
  final List<ProductEntity> products;

  const FavouriteLoaded({required this.favoriteIds, required this.products});

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  @override
  List<Object?> get props => [favoriteIds, products];
}

class FavouriteError extends FavouriteState {
  final String message;
  const FavouriteError(this.message);

  @override
  List<Object?> get props => [message];
}