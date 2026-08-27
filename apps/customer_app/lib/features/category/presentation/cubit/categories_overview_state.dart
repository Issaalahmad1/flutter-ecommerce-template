import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CategoriesOverviewState extends Equatable {
  const CategoriesOverviewState();

  @override
  List<Object?> get props => [];
}

class CategoriesOverviewInitial extends CategoriesOverviewState {
  const CategoriesOverviewInitial();
}

class CategoriesOverviewLoading extends CategoriesOverviewState {
  const CategoriesOverviewLoading();
}

class CategoriesOverviewLoaded extends CategoriesOverviewState {
  final List<CategoryEntity> categories;
  const CategoriesOverviewLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesOverviewError extends CategoriesOverviewState {
  final String message;
  const CategoriesOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}