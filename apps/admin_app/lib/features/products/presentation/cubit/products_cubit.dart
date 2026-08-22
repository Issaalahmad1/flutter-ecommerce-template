  import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  ProductsCubit({
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
  })  : _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        super(const ProductsInitial());

  Future<void> loadProducts() async {
    emit(const ProductsLoading());
    try {
      final results = await Future.wait([
        _productRepository.getProducts(),
        _categoryRepository.getCategories(),
      ]);
      emit(ProductsLoaded(
        products: results[0] as List<ProductEntity>,
        categories: results[1] as List<CategoryEntity>,
      ));
    } catch (e) {
      emit(const ProductsError('حدث خطأ في تحميل المنتجات.'));
    }
  }

  Future<void> createProduct(ProductEntity product) async {
    await _productRepository.createProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(ProductEntity product) async {
    await _productRepository.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _productRepository.deleteProduct(id);
    await loadProducts();
  }
}