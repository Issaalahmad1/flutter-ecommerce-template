import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/// بيحوّل أي مسافة لشرطة تلقائيًا وهي بتتكتب، وبيمنع أي حرف غير
/// مسموح به في ID (بس حروف صغيرة، أرقام، وشرطة) — عشان الأدمن
/// (اللي مش مبرمج) ما يقدرش يغلط حتى لو حاول.
class _CategoryIdFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.toLowerCase().replaceAll(' ', '-');
    text = text.replaceAll(RegExp(r'[^a-z0-9-]'), '');
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

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
  final TextEditingController _newSubcategoryController =
      TextEditingController();
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

    // نجمع كل الفئات الفرعية اللي اتكتبت قبل كده في أي فئة تانية،
    // عشان نعرضها كاقتراحات جاهزة بدل ما الأدمن يكتبها من الصفر.
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
    // الفئات الفرعية الجديدة اللي الأدمن ضافها بنفسه (مش من الاقتراحات).
    final customSubcategories = _selectedSubcategories
        .where((s) => !_suggestedSubcategories.contains(s))
        .toList();

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
                const SizedBox(height: 8),

                TextFormField(
                  controller: _idController,
                  enabled: !_isEditing,
                  inputFormatters: [_CategoryIdFormatter()],
                  decoration: InputDecoration(
                    labelText: 'ID',
                    helperText: _isEditing
                        ? null
                        : 'حروف صغيرة وأرقام بس، بدون مسافات — استخدم شرطة (-) بدلها. مثال: bed-room',
                    helperMaxLines: 2,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose a ready-made icon:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CategoryIconLibrary.icons.entries.map((entry) {
                    final isSelected = _selectedIconKey == entry.value;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedIconKey = isSelected ? null : entry.value;
                      }),
                      child: Container(
                        width: 64,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white24 : Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.lightGreenAccent
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              CategoryIconLibrary.assetPath(entry.value),
                              height: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.key,
                              style: const TextStyle(fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Subcategories',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                if (_suggestedSubcategories.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _suggestedSubcategories.map((sub) {
                      final isSelected = _selectedSubcategories.contains(sub);
                      return FilterChip(
                        label: Text(sub, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _selectedSubcategories.add(sub);
                          } else {
                            _selectedSubcategories.remove(sub);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _newSubcategoryController,
                        decoration: const InputDecoration(
                          labelText: 'Add new subcategory',
                          isDense: true,
                        ),
                        onFieldSubmitted: (_) => _addCustomSubcategory(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _addCustomSubcategory,
                    ),
                  ],
                ),
                if (customSubcategories.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: customSubcategories
                        .map(
                          (sub) => Chip(
                            label: Text(
                              sub,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onDeleted: () => setState(
                              () => _selectedSubcategories.remove(sub),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
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
            const SizedBox(height: 8),

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
