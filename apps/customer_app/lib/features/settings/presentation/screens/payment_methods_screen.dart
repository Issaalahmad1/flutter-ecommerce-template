import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.paymentMethodsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('•••• •••• •••• 4679'),
          ),
          ListTile(leading: const Icon(Icons.payment), title: Text(strings.paypal)),
          ListTile(leading: const Icon(Icons.money), title: Text(strings.cashMoney)),
          const Divider(height: 32),
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: brand.accent),
            title: Text(strings.addNewMethod, style: TextStyle(color: brand.accent)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.paymentComingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }
}