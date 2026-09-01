import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_strings.dart';

/// بيوصّل AppStrings لأي widget عن طريق InheritedWidget القياسي بتاع
/// Flutter (Localizations)، فأي شاشة تقدر تنادي `AppStrings.of(context)`.
class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  static const supportedLocales = [Locale('ar'), Locale('en')];

  @override
  bool isSupported(Locale locale) =>
      supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) {
    final strings = locale.languageCode == 'ar' ? const AppStringsAr() : const AppStringsEn();
    return SynchronousFuture(strings);
  }

  @override
  bool shouldReload(AppStringsDelegate old) => false;
}

extension AppStringsContext on BuildContext {
  AppStrings get strings => Localizations.of<AppStrings>(this, AppStrings)!;
}
