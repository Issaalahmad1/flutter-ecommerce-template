import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../checkout/presentation/screens/checkout_screen.dart';
import '../cubit/cart_state.dart';

/// شريط سفلي فيه تفاصيل الفاتورة (المجموع الفرعي، الخصم، الضريبة،
/// التوصيل، الإجمالي) وزرار الدفع.
class CartSummary extends StatelessWidget {
  final CartLoaded state;

  const CartSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: strings.subtotal, value: state.subtotal),
          if (state.totalDiscount > 0)
            _SummaryRow(label: strings.discount, value: -state.totalDiscount, isDiscount: true),
          _SummaryRow(label: strings.taxAndFees, value: state.tax),
          _SummaryRow(label: strings.delivery, value: state.delivery),
          const Divider(height: 24),
          _SummaryRow(label: strings.total, value: state.total, isBold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CheckoutScreen())),
            child: Text(strings.checkOut),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 18 : 14,
      color: isDiscount ? Colors.green : (isBold ? brand.accent : brand.textSecondary),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('${brand.currencySymbol}${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
