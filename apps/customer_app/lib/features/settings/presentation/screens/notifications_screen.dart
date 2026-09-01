import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // إعدادات محلية بس (State فقط) دلوقتي — مش متصلة بـ Firestore بعد.
  // المفاتيح دي معرّفات داخلية ثابتة، مش نصوص معروضة — النص المعروض
  // بيتحدد وقت الرسم حسب لغة التطبيق (راجع _labelFor).
  final Map<String, bool> _settings = {
    'general': true,
    'sound': true,
    'soundCall': false,
    'vibrate': true,
    'specialOffers': false,
    'payments': true,
    'promo': false,
    'cashback': false,
  };

  String _labelFor(String key, AppStrings strings) => switch (key) {
        'general' => strings.notifGeneral,
        'sound' => strings.notifSound,
        'soundCall' => strings.notifSoundCall,
        'vibrate' => strings.notifVibrate,
        'specialOffers' => strings.notifSpecialOffers,
        'payments' => strings.notifPayments,
        'promo' => strings.notifPromo,
        'cashback' => strings.notifCashback,
        _ => key,
      };

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.notificationsTitle)),
      body: ListView(
        children: _settings.entries
            .map((entry) => SwitchListTile(
                  title: Text(_labelFor(entry.key, strings)),
                  value: entry.value,
                  activeThumbColor: brand.accent,
                  onChanged: (value) => setState(() => _settings[entry.key] = value),
                ))
            .toList(),
      ),
    );
  }
}
