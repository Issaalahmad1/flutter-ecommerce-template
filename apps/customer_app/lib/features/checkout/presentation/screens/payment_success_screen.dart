import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../order/presentation/screens/track_order_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;

  const PaymentSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: brand.accent,
                child: Icon(Icons.check, color: brand.onAccent, size: 44),
              ),
              const SizedBox(height: 24),
              Text(strings.paymentSuccessful, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                strings.paymentSuccessDescription,
                textAlign: TextAlign.center,
                style: TextStyle(color: brand.textSecondary),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => TrackOrderScreen(orderId: orderId),
                    ),
                  );
                },
                child: Text(strings.trackOrder),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}