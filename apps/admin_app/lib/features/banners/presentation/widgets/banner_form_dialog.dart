import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

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
  bool _isSaving = false;

  bool get _isEditing => widget.banner != null;
  DateTime? _expiresAt;
  @override
  void initState() {
    super.initState();
    final banner = widget.banner;
    _titleController = TextEditingController(text: banner?.title ?? '');
    _subtitleController = TextEditingController(text: banner?.subtitle ?? '');
    _discountController = TextEditingController(
      text: banner?.discountLabel ?? '',
    );
    _selectedCategoryId = banner?.categoryId;
    _isActive = banner?.isActive ?? true;
    _expiresAt = banner?.expiresAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final banner = BannerEntity(
      id: widget.banner?.id ?? '',
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      discountLabel: _discountController.text.trim(),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: 'Discount label',
                  helperText: 'مثال: 25%',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Linked category (optional)',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...widget.categories.map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedCategoryId = value),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _expiresAt == null
                      ? 'No expiry date'
                      : 'Expires: ${_expiresAt!.day}/${_expiresAt!.month}/${_expiresAt!.year}',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              _expiresAt ??
                              DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) setState(() => _expiresAt = picked);
                      },
                      child: const Text('Set date'),
                    ),
                    if (_expiresAt != null)
                      TextButton(
                        onPressed: () => setState(() => _expiresAt = null),
                        child: const Text('Clear'),
                      ),
                  ],
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
