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

    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Remember me'),
            value: _rememberMe,
            activeThumbColor: brand.accent,
            onChanged: (v) => setState(() => _rememberMe = v),
          ),
          SwitchListTile(
            title: const Text('Biometric ID'),
            value: _biometric,
            activeThumbColor: brand.accent,
            onChanged: (v) => setState(() => _biometric = v),
          ),
          const ListTile(
            title: Text('Google Authenticator'),
            trailing: Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () {}, child: const Text('Change PIN')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: const Text('Change Password')),
        ],
      ),
    );
  }
}