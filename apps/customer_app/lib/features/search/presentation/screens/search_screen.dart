import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/search_text_field.dart';
import '../widgets/top_searches.dart';

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
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.search)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SearchTextField(
              controller: _controller,
              onSearch: () => _runSearch(_controller.text),
              onOpenFilters: _openFilters,
              onSubmitted: _runSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => _SearchResults(state: state, onSearch: _runSearch),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final SearchState state;
  final ValueChanged<String> onSearch;

  const _SearchResults({required this.state, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return switch (state) {
      SearchInitial() => TopSearches(onTap: onSearch),
      SearchLoading() => const Center(child: CircularProgressIndicator()),
      SearchError(:final message) =>
        Center(child: Text(message, style: TextStyle(color: brand.textSecondary))),
      SearchLoaded(:final results, :final query) => results.isEmpty
          ? Center(
              child: Text(
                query.isEmpty ? strings.noResultsForFilter : strings.noResultsFor(query),
                style: TextStyle(color: brand.textSecondary),
              ),
            )
          : SingleChildScrollView(
              child: ProductGrid(
                products: results,
                onProductTap: (product) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id)),
                ),
              ),
            ),
    };
  }
}
