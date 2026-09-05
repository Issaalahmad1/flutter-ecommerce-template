import 'package:decoze_core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/admin_image_picker.dart';

class OnboardingSlideFormDialog extends StatefulWidget {
  final OnboardingSlideEntity? slide;
  final Future<void> Function(OnboardingSlideEntity) onSubmit;

  const OnboardingSlideFormDialog({super.key, this.slide, required this.onSubmit});

  @override
  State<OnboardingSlideFormDialog> createState() => _OnboardingSlideFormDialogState();
}

class _OnboardingSlideFormDialogState extends State<OnboardingSlideFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleArController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _descriptionArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _orderController;

  Uint8List? _pickedImageBytes;
  String? _existingImageUrl;
  bool _isSaving = false;

  bool get _isEditing => widget.slide != null;

  @override
  void initState() {
    super.initState();
    final slide = widget.slide;
    _titleArController = TextEditingController(text: slide?.titleAr ?? '');
    _titleEnController = TextEditingController(text: slide?.titleEn ?? '');
    _descriptionArController = TextEditingController(text: slide?.descriptionAr ?? '');
    _descriptionEnController = TextEditingController(text: slide?.descriptionEn ?? '');
    _orderController = TextEditingController(text: (slide?.order ?? 0).toString());
    _existingImageUrl = slide?.imageUrl;
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.single.bytes != null) {
      setState(() => _pickedImageBytes = result.files.single.bytes);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    String? imageUrl = _existingImageUrl;
    if (_pickedImageBytes != null) {
      final storageRepository = StorageRepositoryImpl();
      final path = 'onboarding/${DateTime.now().millisecondsSinceEpoch}.jpg';
      imageUrl = await storageRepository.uploadImage(bytes: _pickedImageBytes!, path: path);
    }

    final slide = OnboardingSlideEntity(
      id: widget.slide?.id ?? '',
      imageUrl: imageUrl,
      titleAr: _titleArController.text.trim(),
      titleEn: _titleEnController.text.trim(),
      descriptionAr: _descriptionArController.text.trim(),
      descriptionEn: _descriptionEnController.text.trim(),
      order: int.tryParse(_orderController.text.trim()) ?? 0,
      createdAt: widget.slide?.createdAt ?? DateTime.now(),
    );

    await widget.onSubmit(slide);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit onboarding slide' : 'Add onboarding slide'),
      content: SizedBox(
        width: 420,
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
                  placeholderLabel: 'اختر صورة للسلايد',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleArController,
                  decoration: const InputDecoration(labelText: 'Title (Arabic)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleEnController,
                  decoration: const InputDecoration(labelText: 'Title (English)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionArController,
                  decoration: const InputDecoration(labelText: 'Description (Arabic)'),
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionEnController,
                  decoration: const InputDecoration(labelText: 'Description (English)'),
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _orderController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Order',
                    helperText: 'ترتيب ظهور السلايد — الأصغر يظهر الأول',
                  ),
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
