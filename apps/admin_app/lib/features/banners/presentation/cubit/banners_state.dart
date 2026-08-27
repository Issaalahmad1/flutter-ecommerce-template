import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class BannersState extends Equatable {
  const BannersState();

  @override
  List<Object?> get props => [];
}

class BannersInitial extends BannersState {
  const BannersInitial();
}

class BannersLoading extends BannersState {
  const BannersLoading();
}

class BannersLoaded extends BannersState {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;

  const BannersLoaded({required this.banners, required this.categories});

  @override
  List<Object?> get props => [banners, categories];
}

class BannersError extends BannersState {
  final String message;
  const BannersError(this.message);

  @override
  List<Object?> get props => [message];
}