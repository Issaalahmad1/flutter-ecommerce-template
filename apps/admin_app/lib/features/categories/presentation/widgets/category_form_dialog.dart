import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

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
  late final TextEditingController _subcategoriesController;
  String? _selectedIconKey;
  Uint8List? _pickedImageBytes;
  String? _existingUploadedUrl;
  bool _isSaving = false;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _idController = TextEditingController(text: category?.id ?? '');
    _nameController = TextEditingController(text: category?.name ?? '');

    // لو الفئة (وقت التعديل) كانت أصلاً بتستخدم أيقونة محلية، حدد
    // نفس الأيقونة كمختارة. لو بتستخدم صورة مرفوعة، اعرضها كمعاينة.
    final currentImage = widget.category?.imageUrl;
    if (currentImage != null && CategoryIconLibrary.isLocalIcon(currentImage)) {
      _selectedIconKey = currentImage.split('/').last.replaceAll('.svg', '');
    } else if (currentImage != null && currentImage.isNotEmpty) {
      _existingUploadedUrl = currentImage;
    }

    _subcategoriesController = TextEditingController(
      text: category?.subcategories.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _subcategoriesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _pickedImageBytes = result.files.single.bytes;
        _selectedIconKey = null; // لو رفع صورة، نلغي اختيار الأيقونة الجاهزة تلقائيًا
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final subcategories = _subcategoriesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // ترتيب الأولوية: أيقونة جاهزة ← صورة جديدة مرفوعة ← صورة قديمة
    // موجودة بالفعل (وقت التعديل من غير تغيير).
    String imageUrl;
    if (_selectedIconKey != null) {
      imageUrl = CategoryIconLibrary.assetPath(_selectedIconKey!);
    } else if (_pickedImageBytes != null) {
      final storageRepository = StorageRepositoryImpl();
      final path = 'categories/${DateTime.now().millisecondsSinceEpoch}.jpg';
      imageUrl = await storageRepository.uploadImage(
        bytes: _pickedImageBytes!,
        path: path,
      );
    } else {
      imageUrl = _existingUploadedUrl ?? '';
    }

    final category = CategoryEntity(
      id: _idController.text.trim(),
      name: _nameController.text.trim(),
      imageUrl: imageUrl,
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
        child: SingleChildScrollView(
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
                    helperText: _isEditing
                        ? null
                        : 'مثال: bedroom (حروف صغيرة، من غير مسافات)',
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
                        if (_selectedIconKey != null) {
                          _pickedImageBytes = null; // نلغي الصورة المرفوعة لو اختار أيقونة
                        }
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
                    'Or upload your own image:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                      image: _pickedImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_pickedImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : (_existingUploadedUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_existingUploadedUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                    ),
                    child: (_pickedImageBytes == null && _existingUploadedUrl == null)
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 28),
                                SizedBox(height: 4),
                                Text('اضغط لاختيار صورة', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          )
                        : null,
                  ),
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