import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository;
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  SearchCubit({
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
    SearchRepository? searchRepository,
  })  : _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        _searchRepository = searchRepository ?? SearchRepositoryImpl(),
        super(const SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    try {
      final categories = await _categoryRepository.getCategories();
      final categoryNameToId = {for (final c in categories) c.name: c.id};

      // الخطوة 1: الذكاء الاصطناعي بيحلل سؤال المستخدم لفلاتر منظّمة.
      final intent = await _searchRepository.parseSearchQuery(query, categoryNameToId);

      // الخطوة 2: نجيب المنتجات المرشّحة (بفلتر الفئة والسعر لو موجودين) —
      // لأن Firestore مش بيدعم بحث نصي كامل، فبنجيب مجموعة معقولة.
      final candidates = await _productRepository.getProducts(categoryId: intent.categoryId);
      final priceFiltered = candidates.where((product) {
        final matchesMinPrice = intent.minPrice == null || product.price >= intent.minPrice!;
        final matchesMaxPrice = intent.maxPrice == null || product.price <= intent.maxPrice!;
        return matchesMinPrice && matchesMaxPrice;
      }).toList();

      // الخطوة 3: الذكاء الاصطناعي بيختار المنتجات القريبة من قصد المستخدم
      // بالمعنى (مش بمطابقة نص حرفية) — عشان "خشبي" يطابق "Wooden Chair" مثلاً.
      final matchingIds = await _searchRepository.rankMatchingProducts(query, priceFiltered);
      final productsById = {for (final p in priceFiltered) p.id: p};
      final filtered = matchingIds.map((id) => productsById[id]!).toList();

      emit(SearchLoaded(results: filtered, query: query));
    } catch (e) {
      emit(const SearchError('حدث خطأ أثناء البحث، حاول تاني.'));
    }
  }

  /// فلترة يدوية مباشرة (سعر/فئة/فئة فرعية/لون) — من غير AI، لأن دي
  /// فلاتر منظّمة أصلاً ومحتاجاش تفسير لغة طبيعية.
  Future<void> applyFilters(SearchFilters filters) async {
    emit(const SearchLoading());
    try {
      final products = await _productRepository.getProducts(
        categoryId: filters.categoryId,
        subcategoryId: filters.subcategory,
      );

      final filtered = products.where((product) {
        final matchesPrice = product.price <= filters.maxPrice;
        final matchesColor =
            filters.colors.isEmpty || filters.colors.contains(product.color);
        return matchesPrice && matchesColor;
      }).toList();

      emit(SearchLoaded(results: filtered, query: ''));
    } catch (e) {
      emit(const SearchError('حدث خطأ أثناء الفلترة، حاول تاني.'));
    }
  }
}