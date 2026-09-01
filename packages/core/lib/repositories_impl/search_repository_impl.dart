import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../entities/product_entity.dart';
import '../repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  late final GenerativeModel _model;

  SearchRepositoryImpl() {
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.6-flash');
  }

  @override
  Future<SearchIntent> parseSearchQuery(
    String query,
    Map<String, String> categoryNameToId,
  ) async {
    final categoryNames = categoryNameToId.keys.toList();
    final prompt = '''
انت مساعد بحث لتطبيق أثاث وديكور منزلي. حلّل سؤال المستخدم ده وارجع فلاتر بحث
بصيغة JSON بس، من غير أي نص إضافي أو شرح.

أسماء الفئات المتاحة: ${categoryNames.join(', ')}

سؤال المستخدم: "$query"

أرجع JSON بالشكل ده بالظبط:
{
  "keywords": ["كلمة1", "كلمة2"],
  "categoryName": "اسم الفئة بالظبط زي ما هو في القايمة فوق لو مذكورة صراحة أو ضمنيًا، أو null",
  "minPrice": رقم أو null,
  "maxPrice": رقم أو null
}
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '{}';

      // الذكاء الاصطناعي أحيانًا بيحيط الـ JSON بعلامات ```json```، بنشيلها.
      final cleanedText = text.replaceAll(RegExp(r'```json|```'), '').trim();
      final json = jsonDecode(cleanedText) as Map<String, dynamic>;

      final categoryName = json['categoryName'] as String?;
      // بنحوّل اسم الفئة لـ ID حقيقي من عندنا بدل ما نصدّق أي ID
      // يمكن الذكاء الاصطناعي يكون اخترعه.
      final categoryId = categoryName == null ? null : categoryNameToId[categoryName];

      final intent = SearchIntent(
        keywords: (json['keywords'] as List?)?.map((e) => e.toString()).toList() ?? [],
        categoryId: categoryId,
        minPrice: (json['minPrice'] as num?)?.toDouble(),
        maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      );

      return intent;
    } catch (e) {
      debugPrint('== parseSearchQuery AI call failed: $e ==');
      // لو الذكاء الاصطناعي فشل لأي سبب (شبكة، تحليل خاطئ)، نرجع بحث
      // بسيط بالكلمة نفسها بدل ما نكسر الشاشة بالكامل.
      return SearchIntent(keywords: [query]);
    }
  }

  @override
  Future<List<String>> rankMatchingProducts(
    String query,
    List<ProductEntity> candidates,
  ) async {
    if (candidates.isEmpty) return [];

    final productList = candidates.map((p) {
      final shortDescription =
          p.description.length > 120 ? '${p.description.substring(0, 120)}...' : p.description;
      return {
        'id': p.id,
        'name': p.name,
        'description': shortDescription,
        'price': p.price,
      };
    }).toList();

    final prompt = '''
انت محرك بحث ذكي لتطبيق أثاث وديكور منزلي. عندك سؤال بحث من المستخدم وقايمة منتجات،
ومطلوب تختار المنتجات القريبة من قصده بالمعنى — حتى لو الكلمات مختلفة تمامًا عن اسم
المنتج. مثلاً "خشبي" لازم يطابق منتج اسمه "Wooden Chair"، و"رخيص" يعني سعر منخفض
نسبيًا بين المنتجات المتاحة، و"غرفة نوم" ممكن يطابق منتجات زي "Bed" أو "Nightstand".
افهم المرادفات والترجمة بين العربي والإنجليزي واللهجات المصرية.

سؤال المستخدم: "$query"

المنتجات المتاحة:
${jsonEncode(productList)}

أرجع JSON array بس فيه IDs المنتجات المطابقة، مرتّبة من الأكثر صلة للأقل، من غير
أي نص إضافي أو شرح. لو مفيش منتجات مطابقة أرجع array فاضية. مثال:
["id1", "id2"]
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '[]';

      // الذكاء الاصطناعي أحيانًا بيحيط الـ JSON بعلامات ```json```، بنشيلها.
      final cleanedText = text.replaceAll(RegExp(r'```json|```'), '').trim();
      final ids = (jsonDecode(cleanedText) as List).map((e) => e.toString()).toList();

      // بنتأكد إن الـ IDs الراجعة فعلاً موجودة في المرشّحين، احتياطًا لو
      // الذكاء الاصطناعي هلوسن ID مش موجود.
      final candidateIds = candidates.map((p) => p.id).toSet();
      return ids.where(candidateIds.contains).toList();
    } catch (e, st) {
      debugPrint('== rankMatchingProducts AI call failed: $e ==');
      debugPrint('== stack: $st ==');
      // لو الذكاء الاصطناعي فشل، نرجع مطابقة بسيطة بالاسم/الوصف بدل ما
      // نرجع نتايج فاضية بالكامل.
      final lowerQuery = query.toLowerCase();
      return candidates
          .where((p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery))
          .map((p) => p.id)
          .toList();
    }
  }
}