import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _rememberMe = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.securityTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(strings.rememberMe),
            value: _rememberMe,
            activeThumbColor: brand.accent,
            onChanged: (v) => setState(() => _rememberMe = v),
          ),
          SwitchListTile(
            title: Text(strings.biometricId),
            value: _biometric,
            activeThumbColor: brand.accent,
            onChanged: (v) => setState(() => _biometric = v),
          ),
          ListTile(
            title: Text(strings.googleAuthenticator),
            trailing: const Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: Text(strings.changePin)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: Text(strings.changePassword)),
        ],
      ),
    );
  }
}