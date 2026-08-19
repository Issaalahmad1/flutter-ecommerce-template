import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductInitial());

  Future<void> loadProduct(String productId) async {
    emit(const ProductLoading());
    try {
      final results = await Future.wait([
        _productRepository.getProductById(productId),
        _productRepository.getReviews(productId),
      ]);

      emit(ProductLoaded(
        product: results[0] as ProductEntity,
        reviews: results[1] as List<ReviewEntity>,
      ));
    } catch (e) {
      emit(const ProductError('حدث خطأ في تحميل تفاصيل المنتج.'));
    }
  }
}