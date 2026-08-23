import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class CategoryFormDialog extends StatefulWidget {
  final CategoryEntity? category;
  final Future<void> Function(CategoryEntity, {required bool isNew}) onSubmit;

  const CategoryFormDialog({super.key, this.category, required this.onSubmit});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _imageController;
  late final TextEditingController _subcategoriesController;
  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _idController = TextEditingController(text: category?.id ?? '');
    _nameController = TextEditingController(text: category?.name ?? '');
    _imageController = TextEditingController(text: category?.imageUrl ?? '');
    _subcategoriesController =
        TextEditingController(text: category?.subcategories.join(', ') ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _imageController.dispose();
    _subcategoriesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final subcategories = _subcategoriesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final category = CategoryEntity(
      id: _idController.text.trim(),
      name: _nameController.text.trim(),
      imageUrl: _imageController.text.trim(),
      order: widget.category?.order ?? 0,
      subcategories: subcategories,
    );

    await widget.onSubmit(category, isNew: !_isEditing);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit category' : 'Add category'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                enabled: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'ID',
                  helperText: _isEditing ? null : 'مثال: bedroom (حروف صغيرة، من غير مسافات)',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subcategoriesController,
                decoration: const InputDecoration(
                  labelText: 'Subcategories',
                  helperText: 'افصل بينهم بفاصلة، مثال: Sofa, Tables, Decor',
                ),
              ),
            ],
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