import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_form_dialog.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(
        productRepository: ProductRepositoryImpl(),
        categoryRepository: CategoryRepositoryImpl(),
      )..loadProducts(),
      child: const _ProductsScreenBody(),
    );
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody();

  void _openForm(
    BuildContext context,
    List<CategoryEntity> categories, {
    ProductEntity? product,
  }) {
    final cubit = context.read<ProductsCubit>();
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        categories: categories,
        product: product,
        onSubmit: (result) async {
          if (product == null) {
            await cubit.createProduct(result);
          } else {
            await cubit.updateProduct(result);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductEntity product) {
    final cubit = context.read<ProductsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف "${product.name}"؟'),
        content: const Text('هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deleteProduct(product.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return switch (state) {
          ProductsInitial() ||
          ProductsLoading() => const Center(child: CircularProgressIndicator()),
          ProductsError(:final message) => Center(child: Text(message)),
          ProductsLoaded(:final products, :final categories) =>
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
                        onPressed: () => _openForm(context, categories),
                        icon: const Icon(Icons.add),
                        label: const Text('Add product'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Stock')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('')),
                      ],
                      rows: products.map((product) {
                        final categoryName = categories
                            .firstWhere(
                              (c) => c.id == product.categoryId,
                              orElse: () => CategoryEntity(
                                id: '',
                                name: '—',
                                imageUrl: '',
                              ),
                            )
                            .name;

                        return DataRow(
                          cells: [
                            DataCell(Text(product.name)),
                            DataCell(Text(categoryName)),
                            DataCell(
                              Text(
                                '${brand.currencySymbol}${product.price.toStringAsFixed(2)}',
                              ),
                            ),
                            DataCell(Text('${product.stock}')),
                            DataCell(Text(product.status.name)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _openForm(
                                      context,
                                      categories,
                                      product: product,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _confirmDelete(context, product),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}
