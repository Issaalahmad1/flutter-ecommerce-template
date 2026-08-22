import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // إعدادات محلية بس (State فقط) دلوقتي — مش متصلة بـ Firestore بعد.
  final Map<String, bool> _settings = {
    'General Notification': true,
    'Sound': true,
    'Sound Call': false,
    'Vibrate': true,
    'Special Offers': false,
    'Payments': true,
    'Promo and discount': false,
    'Cashback': false,
  };

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: _settings.entries
            .map((entry) => SwitchListTile(
                  title: Text(entry.key),
                  value: entry.value,
                  activeThumbColor: brand.accent,
                  onChanged: (value) => setState(() => _settings[entry.key] = value),
                ))
            .toList(),
      ),
    );
  }
}