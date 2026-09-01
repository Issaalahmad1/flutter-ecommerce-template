import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_filter_sheet.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        productRepository: ProductRepositoryImpl(),
        categoryRepository: CategoryRepositoryImpl(),
      ),
      child: const _SearchScreenBody(),
    );
  }
}

class _SearchScreenBody extends StatefulWidget {
  const _SearchScreenBody();

  @override
  State<_SearchScreenBody> createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<_SearchScreenBody> {
  final _controller = TextEditingController();
  SearchFilters _filters = const SearchFilters();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSearch(String query) {
    if (query.trim().isEmpty) return;
    _controller.text = query;
    context.read<SearchCubit>().search(query);
  }

  Future<void> _openFilters() async {
    final cubit = context.read<SearchCubit>();
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SearchFilterSheet(initialFilters: _filters),
    );
    if (result == null || !mounted) return;
    setState(() => _filters = result);
    _controller.clear();
    cubit.applyFilters(result);
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.search)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,

                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: brand.textPrimary),
                    decoration: InputDecoration(
                      fillColor: brand.surface,
                      hintText: strings.searchHint,
                      hintStyle: TextStyle(color: brand.textSecondary),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search, color: brand.textSecondary),
                        onPressed: () => _runSearch(_controller.text),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: _openFilters,
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.all(12),
                          decoration:  BoxDecoration(
                            color: brand.accent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(Icons.tune, color: brand.onAccent),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: const Color(0xff5A5D5F),
                          width: 0.3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: const Color(0xff5A5D5F),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: const Color(0xff5A5D5F),
                          width: 0.8,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onSubmitted: _runSearch,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchInitial() => _TopSearches(
                      onTap: _runSearch,
                      brand: brand,
                    ),
                    SearchLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    SearchError(:final message) => Center(
                      child: Text(
                        message,
                        style: TextStyle(color: brand.textSecondary),
                      ),
                    ),
                    SearchLoaded(:final results, :final query) =>
                      results.isEmpty
                          ? Center(
                              child: Text(
                                query.isEmpty
                                    ? strings.noResultsForFilter
                                    : strings.noResultsFor(query),
                                style: TextStyle(color: brand.textSecondary),
                              ),
                            )
                          : SingleChildScrollView(
                              child: ProductGrid(
                                products: results,
                                onProductTap: (product) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        productId: product.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSearches extends StatelessWidget {
  final ValueChanged<String> onTap;
  final BrandConfig brand;

  const _TopSearches({required this.onTap, required this.brand});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.strings.topSearches,
            style: TextStyle(
              color: brand.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final term in context.strings.topSearchSuggestions)
                GestureDetector(
                  onTap: () => onTap(term),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: brand.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      term,
                      style: TextStyle(color: brand.textPrimary),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
