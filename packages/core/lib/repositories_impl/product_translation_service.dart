import 'package:firebase_ai/firebase_ai.dart';

/// بيترجم نص وصف منتج عند الطلب بس (lazy) — بالظبط زي رابط "See
/// translation" اللي إنستجرام بيستخدمه تحت التعليقات: من غير ترجمة كل
/// حاجة مقدمًا، وبس لما المستخدم يدوس فعليًا.
class ProductTranslationService {
  late final GenerativeModel _model;

  ProductTranslationService() {
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.6-flash');
  }

  /// كشف بسيط وسريع (من غير أي طلب شبكة) لو النص عربي — كافي بما إننا
  /// بندعم عربي/إنجليزي بس دلوقتي.
  static bool looksArabic(String text) => RegExp(r'[؀-ۿ]').hasMatch(text);

  Future<String> translate(String text, {required String targetLanguageName}) async {
    final prompt = '''
Translate the following text to $targetLanguageName. Return ONLY the translation, no explanation, no quotes:

$text
''';
    final response = await _model.generateContent([Content.text(prompt)]);
    return (response.text ?? text).trim();
  }
}
