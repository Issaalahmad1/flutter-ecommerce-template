import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final BannerRepository _bannerRepository;

  ProductCubit({
    required ProductRepository productRepository,
    BannerRepository? bannerRepository,
  })  : _productRepository = productRepository,
        _bannerRepository = bannerRepository ?? BannerRepositoryImpl(),
        super(const ProductInitial());

  Future<void> loadProduct(String productId) async {
    emit(const ProductLoading());
    try {
      final product = await _productRepository.getProductById(productId);
      final results = await Future.wait([
        _productRepository.getReviews(productId),
        _bannerRepository.getBanners(),
      ]);

      final banners = results[1] as List<BannerEntity>;
      final activeDiscount =
          DiscountCalculator.findActiveDiscount(banners, product.categoryId);

      emit(ProductLoaded(
        product: product,
        reviews: results[0] as List<ReviewEntity>,
        discountPercent: activeDiscount?.discountPercent,
      ));
    } catch (e) {
      emit(const ProductError('حدث خطأ في تحميل تفاصيل المنتج.'));
    }
  }
}