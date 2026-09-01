import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

/// الفلاتر اليدوية اللي المستخدم بيختارها من شاشة الفلترة — منفصلة عن
/// البحث بالذكاء الاصطناعي، وبتتفلتر مباشرة من غير أي تحليل AI.
class SearchFilters extends Equatable {
  final String? categoryId;
  final String? subcategory;
  final double maxPrice;
  final Set<String> colors;

  const SearchFilters({
    this.categoryId,
    this.subcategory,
    this.maxPrice = 1500,
    this.colors = const {},
  });

  bool get isEmpty =>
      categoryId == null && subcategory == null && colors.isEmpty && maxPrice >= 1500;

  SearchFilters copyWith({
    String? categoryId,
    bool clearCategoryId = false,
    String? subcategory,
    bool clearSubcategory = false,
    double? maxPrice,
    Set<String>? colors,
  }) {
    return SearchFilters(
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      subcategory: clearSubcategory ? null : (subcategory ?? this.subcategory),
      maxPrice: maxPrice ?? this.maxPrice,
      colors: colors ?? this.colors,
    );
  }

  @override
  List<Object?> get props => [categoryId, subcategory, maxPrice, colors];
}

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<ProductEntity> results;
  final String query;

  const SearchLoaded({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}