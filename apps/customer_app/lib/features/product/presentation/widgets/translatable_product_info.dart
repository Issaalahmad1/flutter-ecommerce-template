import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// اسم ووصف المنتج + رابط "ترجمة" واحد تحتهم لو لغة المحتوى مختلفة عن
/// لغة التطبيق الحالية — بالظبط نفس فكرة "See translation" في
/// إنستجرام: مفيش ترجمة مقدّمًا، بس أول ضغطة بتترجم الاسم والوصف
/// مع بعض وبتتحفظ في المنتج نفسه عشان أي حد تاني ياخدها جاهزة من
/// غير ما نطلب من الذكاء الاصطناعي تاني.
class TranslatableProductInfo extends StatefulWidget {
  final ProductEntity product;

  const TranslatableProductInfo({super.key, required this.product});

  @override
  State<TranslatableProductInfo> createState() => _TranslatableProductInfoState();
}

class _TranslatableProductInfoState extends State<TranslatableProductInfo> {
  String? _translatedName;
  String? _translatedDescription;
  bool _showingTranslation = false;
  bool _isTranslating = false;

  bool get _shouldOfferTranslation {
    final locale = Localizations.localeOf(context).languageCode;
    final isArabicText = ProductTranslationService.looksArabic(widget.product.name) ||
        ProductTranslationService.looksArabic(widget.product.description);
    return (locale == 'ar' && !isArabicText) || (locale == 'en' && isArabicText);
  }

  Future<void> _toggleTranslation() async {
    if (_showingTranslation) {
      setState(() => _showingTranslation = false);
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final cachedName = locale == 'ar' ? widget.product.nameAr : widget.product.nameEn;
    final cachedDescription =
        locale == 'ar' ? widget.product.descriptionAr : widget.product.descriptionEn;
    if (cachedName != null && cachedDescription != null) {
      setState(() {
        _translatedName = cachedName;
        _translatedDescription = cachedDescription;
        _showingTranslation = true;
      });
      return;
    }

    setState(() => _isTranslating = true);
    try {
      final targetLanguageName = locale == 'ar' ? 'Arabic' : 'English';
      final service = ProductTranslationService();
      final results = await Future.wait([
        service.translate(widget.product.name, targetLanguageName: targetLanguageName),
        service.translate(widget.product.description, targetLanguageName: targetLanguageName),
      ]);
      if (!mounted) return;
      setState(() {
        _translatedName = results[0];
        _translatedDescription = results[1];
        _showingTranslation = true;
        _isTranslating = false;
      });
      final updated = locale == 'ar'
          ? widget.product.copyWith(nameAr: results[0], descriptionAr: results[1])
          : widget.product.copyWith(nameEn: results[0], descriptionEn: results[1]);
      // مش محتاجين ننتظر الحفظ — العرض للمستخدم الحالي خلص أصلاً.
      ProductRepositoryImpl().updateProduct(updated);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showingTranslation && _translatedName != null
              ? _translatedName!
              : widget.product.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          _showingTranslation && _translatedDescription != null
              ? _translatedDescription!
              : widget.product.description,
          style: TextStyle(color: brand.textSecondary, height: 1.5),
        ),
        if (_shouldOfferTranslation || _showingTranslation) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _isTranslating ? null : _toggleTranslation,
            child: Text(
              _isTranslating
                  ? strings.translating
                  : (_showingTranslation ? strings.showOriginal : strings.seeTranslation),
              style: TextStyle(
                color: brand.accent,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: brand.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
