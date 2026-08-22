import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class ProductFormDialog extends StatefulWidget {
  final List<CategoryEntity> categories;
  final ProductEntity? product;
  final Future<void> Function(ProductEntity) onSubmit;

  const ProductFormDialog({
    super.key,
    required this.categories,
    required this.onSubmit,
    this.product,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _imageController;
  late String? _selectedCategoryId;
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(text: product?.description ?? '');
    _priceController = TextEditingController(text: product?.price.toString() ?? '');
    _stockController = TextEditingController(text: product?.stock.toString() ?? '');
    _imageController = TextEditingController(text: product?.thumbnail ?? '');
    _selectedCategoryId = product?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) return;

    setState(() => _isSaving = true);

    final product = ProductEntity(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      images: [_imageController.text.trim()],
      categoryId: _selectedCategoryId!,
      rating: widget.product?.rating ?? 0,
      reviewCount: widget.product?.reviewCount ?? 0,
      stock: int.parse(_stockController.text.trim()),
      isFeatured: widget.product?.isFeatured ?? false,
      status: ProductStatus.active,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );

    await widget.onSubmit(product);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit product' : 'Add product'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: widget.categories
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategoryId = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) =>
                            (double.tryParse(v ?? '') == null) ? 'رقم غير صحيح' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stockController,
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (v) => (int.tryParse(v ?? '') == null) ? 'رقم غير صحيح' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}