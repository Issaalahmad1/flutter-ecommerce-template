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
  final List<ProductEntity> allProducts;
  final List<BannerEntity> banners;

  const HomeLoaded({
    required this.categories,
    required this.allProducts,
    required this.banners,
  });

  /// الأكثر مبيعًا فعليًا — مرتّبين حسب `salesCount` (بيتزوّد أوتوماتيك
  /// مع كل طلب فيه المنتج، مش رقم بيحطه الأدمن يدويًا).
  List<ProductEntity> get topSellingProducts {
    final sorted = [...allProducts]
      ..sort((a, b) => b.salesCount.compareTo(a.salesCount));
    return sorted.take(10).toList();
  }

  /// الأعلى تقييمًا — نفس منتجات الكتالوج، بس مرتّبين حسب `rating`.
  List<ProductEntity> get topRatedProducts {
    final sorted = [...allProducts]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(10).toList();
  }

  @override
  List<Object?> get props => [categories, allProducts, banners];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
