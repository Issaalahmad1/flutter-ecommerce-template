import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments Methods')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('•••• •••• •••• 4679'),
          ),
          const ListTile(leading: Icon(Icons.payment), title: Text('PayPal')),
          const ListTile(leading: Icon(Icons.money), title: Text('Cash Money')),
          const Divider(height: 32),
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: brand.accent),
            title: Text('Add New Method', style: TextStyle(color: brand.accent)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('هتتفعّل مع بوابة دفع حقيقية لاحقًا.')),
              );
            },
          ),
        ],
      ),
    );
  }
}