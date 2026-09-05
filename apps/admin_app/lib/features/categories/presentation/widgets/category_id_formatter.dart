import 'package:flutter/services.dart';

/// بيحوّل أي مسافة لشرطة تلقائيًا وهي بتتكتب، وبيمنع أي حرف غير مسموح
/// به في ID (بس حروف صغيرة، أرقام، وشرطة) — عشان الأدمن (اللي مش
/// مبرمج) ما يقدرش يغلط حتى لو حاول.
class CategoryIdFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.toLowerCase().replaceAll(' ', '-');
    text = text.replaceAll(RegExp(r'[^a-z0-9-]'), '');
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
