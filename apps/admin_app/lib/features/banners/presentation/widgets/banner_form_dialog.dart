import 'package:decoze_core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/admin_image_picker.dart';
import 'banner_expiry_picker.dart';

class BannerFormDialog extends StatefulWidget {
  final List<CategoryEntity> categories;
  final BannerEntity? banner;
  final Future<void> Function(BannerEntity) onSubmit;

  const BannerFormDialog({
    super.key,
    required this.categories,
    required this.onSubmit,
    this.banner,
  });

  @override
  State<BannerFormDialog> createState() => _BannerFormDialogState();
}

class _BannerFormDialogState extends State<BannerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _discountController;
  String? _selectedCategoryId;
  late bool _isActive;
  DateTime? _expiresAt;

  Uint8List? _pickedImageBytes; // صورة جديدة اتختارت لسه ماترفعتش
  String? _existingImageUrl; // رابط الصورة القديمة (لو بنعدّل بانر موجود)
  bool _isSaving = false;

  bool get _isEditing => widget.banner != null;

  @override
  void initState() {
    super.initState();
    final banner = widget.banner;
    _titleController = TextEditingController(text: banner?.title ?? '');
    _subtitleController = TextEditingController(text: banner?.subtitle ?? '');
    _discountController = TextEditingController(text: banner?.discountLabel ?? '');
    _selectedCategoryId = banner?.categoryId;
    _isActive = banner?.isActive ?? true;
    _expiresAt = banner?.expiresAt;
    _existingImageUrl = banner?.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // مهم على الويب — بيرجّع البايتات مباشرة
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() => _pickedImageBytes = result.files.single.bytes);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    String? imageUrl = _existingImageUrl;

    // لو الأدمن اختار صورة جديدة، ارفعها الأول وهات رابطها الحقيقي
    if (_pickedImageBytes != null) {
      final storageRepository = StorageRepositoryImpl();
      final path = 'banners/${DateTime.now().millisecondsSinceEpoch}.jpg';
      imageUrl = await storageRepository.uploadImage(bytes: _pickedImageBytes!, path: path);
    }

    final banner = BannerEntity(
      id: widget.banner?.id ?? '',
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      discountLabel: _discountController.text.trim(),
      imageUrl: imageUrl,
      categoryId: _selectedCategoryId,
      isActive: _isActive,
      expiresAt: _expiresAt,
      order: widget.banner?.order ?? 0,
      createdAt: widget.banner?.createdAt ?? DateTime.now(),
    );

    await widget.onSubmit(banner);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit banner' : 'Add banner'),
      content: SizedBox(
        width: 420,
        height: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminImagePicker(
                  pickedImageBytes: _pickedImageBytes,
                  existingImageUrl: _existingImageUrl,
                  onTap: _pickImage,
                  placeholderLabel: 'اختر صورة للبانر',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(labelText: 'Subtitle'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Discount percentage',
                    suffixText: '%',
                    helperText: 'رقم من 1 إلى 100',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'مطلوب';
                    final number = int.tryParse(v.trim());
                    if (number == null || number < 1 || number > 100) {
                      return 'أدخل رقم من 1 إلى 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Linked category (optional)'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...widget.categories.map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedCategoryId = value),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                const SizedBox(height: 8),
                BannerExpiryPicker(
                  expiresAt: _expiresAt,
                  onChanged: (value) => setState(() => _expiresAt = value),
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
