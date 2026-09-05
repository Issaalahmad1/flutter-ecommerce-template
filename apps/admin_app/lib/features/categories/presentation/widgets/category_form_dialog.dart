import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import 'category_icon_picker.dart';
import 'category_id_formatter.dart';
import 'category_subcategories_field.dart';

class CategoryFormDialog extends StatefulWidget {
  final CategoryEntity? category;
  final List<CategoryEntity> allCategories;
  final Future<void> Function(CategoryEntity, {required bool isNew}) onSubmit;

  const CategoryFormDialog({
    super.key,
    this.category,
    required this.allCategories,
    required this.onSubmit,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  final TextEditingController _newSubcategoryController = TextEditingController();
  String? _selectedIconKey;
  final Set<String> _selectedSubcategories = {};
  late final List<String> _suggestedSubcategories;
  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _idController = TextEditingController(text: category?.id ?? '');
    _nameController = TextEditingController(text: category?.name ?? '');
    _selectedSubcategories.addAll(category?.subcategories ?? []);

    // نجمع كل الفئات الفرعية اللي اتكتبت قبل كده في أي فئة تانية، عشان
    // نعرضها كاقتراحات جاهزة بدل ما الأدمن يكتبها من الصفر.
    final allSubs = <String>{};
    for (final c in widget.allCategories) {
      allSubs.addAll(c.subcategories);
    }
    _suggestedSubcategories = allSubs.toList()..sort();

    final currentImage = widget.category?.imageUrl;
    if (currentImage != null && CategoryIconLibrary.isLocalIcon(currentImage)) {
      _selectedIconKey = currentImage.split('/').last.replaceAll('.svg', '');
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _newSubcategoryController.dispose();
    super.dispose();
  }

  void _addCustomSubcategory() {
    final value = _newSubcategoryController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _selectedSubcategories.add(value);
      _newSubcategoryController.clear();
    });
  }

  void _toggleSuggestedSubcategory(String sub) {
    setState(() {
      if (_selectedSubcategories.contains(sub)) {
        _selectedSubcategories.remove(sub);
      } else {
        _selectedSubcategories.add(sub);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final imageUrl = _selectedIconKey != null
        ? CategoryIconLibrary.assetPath(_selectedIconKey!)
        : widget.category?.imageUrl ?? '';

    final category = CategoryEntity(
      id: _idController.text.trim(),
      name: _nameController.text.trim(),
      imageUrl: imageUrl,
      order: widget.category?.order ?? 0,
      subcategories: _selectedSubcategories.toList(),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _idController,
                  enabled: !_isEditing,
                  inputFormatters: [CategoryIdFormatter()],
                  decoration: InputDecoration(
                    labelText: 'ID',
                    helperText: _isEditing
                        ? null
                        : 'حروف صغيرة وأرقام بس، بدون مسافات — استخدم شرطة (-) بدلها. مثال: bed-room',
                    helperMaxLines: 2,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                CategoryIconPicker(
                  selectedIconKey: _selectedIconKey,
                  onChanged: (value) => setState(() => _selectedIconKey = value),
                ),
                const SizedBox(height: 16),
                CategorySubcategoriesField(
                  selectedSubcategories: _selectedSubcategories,
                  suggestedSubcategories: _suggestedSubcategories,
                  newSubcategoryController: _newSubcategoryController,
                  onToggleSuggested: _toggleSuggestedSubcategory,
                  onAddCustom: _addCustomSubcategory,
                  onRemoveCustom: (sub) => setState(() => _selectedSubcategories.remove(sub)),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
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
