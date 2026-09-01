
import 'package:decoze_core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// عنصر صورة واحد في المعرض — إما رابط قديم موجود بالفعل، أو بايتات
/// صورة جديدة لسه في الذاكرة. الترتيب في القايمة بتاعة الفورم هو
/// اللي بيحدد "مين الأساسية" (أول عنصر دايمًا).
class _GalleryImage {
  final String? existingUrl;
  final Uint8List? bytes;

  _GalleryImage.existing(this.existingUrl) : bytes = null;
  _GalleryImage.picked(this.bytes) : existingUrl = null;

  ImageProvider get provider => bytes != null
      ? MemoryImage(bytes!)
      : NetworkImage(existingUrl!) as ImageProvider;
}

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
  late String? _selectedCategoryId;
  late String? _selectedColor;
  late String? _selectedSubcategory;

  final List<_GalleryImage> _images = [];
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  List<String> get _currentSubcategories {
    for (final category in widget.categories) {
      if (category.id == _selectedCategoryId) return category.subcategories;
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    for (final url in product?.images ?? []) {
      _images.add(_GalleryImage.existing(url));
    }
    _selectedCategoryId =
        product?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : null);
    _selectedColor = product?.color;
    _selectedSubcategory = product?.subcategoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: true,
    );
    if (result == null) return;

    setState(() {
      for (final file in result.files) {
        if (file.bytes != null) {
          _images.add(_GalleryImage.picked(file.bytes!));
        }
      }
    });
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  /// بتنقل الصورة المختارة لأول مكان في القايمة، فتبقى هي "الأساسية"
  /// تلقائيًا (بما إن images[0] هي اللي بتُستخدم كصورة الكارت).
  void _setAsPrimary(int index) {
    if (index == 0) return;
    setState(() {
      final image = _images.removeAt(index);
      _images.insert(0, image);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('أضف صورة واحدة على الأقل')));
      return;
    }

    setState(() => _isSaving = true);

    // نرفع الصور الجديدة بس (اللي لسه بايتات في الذاكرة)، ونسيب
    // الصور القديمة زي ما هي، مع الحفاظ على نفس ترتيب المعرض.
    final storageRepository = StorageRepositoryImpl();
    final finalUrls = <String>[];
    for (var i = 0; i < _images.length; i++) {
      final image = _images[i];
      if (image.existingUrl != null) {
        finalUrls.add(image.existingUrl!);
      } else {
        final path = 'products/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final url = await storageRepository.uploadImage(
          bytes: image.bytes!,
          path: path,
        );
        finalUrls.add(url);
      }
    }

    final product = ProductEntity(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      images: finalUrls,
      categoryId: _selectedCategoryId!,
      subcategoryId: _selectedSubcategory,
      rating: widget.product?.rating ?? 0,
      reviewCount: widget.product?.reviewCount ?? 0,
      stock: int.parse(_stockController.text.trim()),
      isFeatured: widget.product?.isFeatured ?? false,
      status: ProductStatus.active,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      color: _selectedColor,
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
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: widget.categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedCategoryId = value;
                    // لو الفئة اتغيّرت، الفئة الفرعية القديمة ممكن متبقاش
                    // موجودة في قايمة الفئة الجديدة.
                    if (!_currentSubcategories.contains(_selectedSubcategory)) {
                      _selectedSubcategory = null;
                    }
                  }),
                ),
                if (_currentSubcategories.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedSubcategory,
                    decoration: const InputDecoration(
                      labelText: 'Subcategory (optional)',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('—')),
                      for (final sub in _currentSubcategories)
                        DropdownMenuItem(value: sub, child: Text(sub)),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedSubcategory = value),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$'),
                          ),
                        ],
                        validator: (v) {
                          final value = double.tryParse(v ?? '');
                          if (value == null) return 'أدخل رقم صحيح';
                          if (value <= 0) return 'السعر لازم يكون أكبر من صفر';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stockController,
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (v) => (int.tryParse(v ?? '') == null)
                            ? 'رقم غير صحيح'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Color (optional)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ColorSwatch(
                      color: null,
                      isSelected: _selectedColor == null,
                      onTap: () => setState(() => _selectedColor = null),
                    ),
                    for (final entry in ProductColorPalette.colors.entries)
                      _ColorSwatch(
                        color: ProductColorPalette.toColor(entry.value),
                        label: entry.key,
                        isSelected: _selectedColor == entry.value,
                        onTap: () => setState(() => _selectedColor = entry.value),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Product images',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    if (_images.isNotEmpty)
                      Text(
                        '(اضغط على النجمة لتحديد الصورة الأساسية)',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var i = 0; i < _images.length; i++)
                      _ImageThumbnail(
                        image: _images[i].provider,
                        isPrimary: i == 0,
                        onRemove: () => _removeImage(i),
                        onSetPrimary: () => _setAsPrimary(i),
                      ),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(Icons.add_photo_alternate_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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

class _ImageThumbnail extends StatelessWidget {
  final ImageProvider image;
  final bool isPrimary;
  final VoidCallback onRemove;
  final VoidCallback onSetPrimary;

  const _ImageThumbnail({
    required this.image,
    required this.isPrimary,
    required this.onRemove,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: image, fit: BoxFit.cover),
              border: isPrimary
                  ? Border.all(color: Colors.lightGreenAccent, width: 2)
                  : null,
            ),
          ),
          // نجمة تحديد "الأساسية" — تفضل ظاهرة دايمًا، لكن ملونة بس
          // لو دي فعلاً الصورة الأساسية حاليًا.
          Positioned(
            bottom: 2,
            left: 2,
            child: GestureDetector(
              onTap: onSetPrimary,
              child: Icon(
                isPrimary ? Icons.star : Icons.star_border,
                size: 18,
                color: isPrimary ? Colors.lightGreenAccent : Colors.white70,
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// دائرة لون واحدة قابلة للاختيار — لو [color] كان null، دي خيار
/// "بدون لون" (زي X)، مفيدة للمنتجات اللي مالهاش لون محدد.
class _ColorSwatch extends StatelessWidget {
  final Color? color;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: label ?? 'بدون لون',
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.lightGreenAccent : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: color == null
              ? const Icon(Icons.close, size: 16, color: Colors.white54)
              : null,
        ),
      ),
    );
  }
}
