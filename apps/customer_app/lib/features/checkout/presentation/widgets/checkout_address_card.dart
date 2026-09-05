import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../address/presentation/screens/address_form_screen.dart';

/// كارت العنوان في أول صفحة الدفع — بيعرض العنوان الافتراضي/المختار
/// لو موجود (والضغط عليه يفتح شاشة اختيار عنوان تاني)، أو دعوة لإضافة
/// عنوان جديد لو مفيش أي عنوان محفوظ أصلاً.
class CheckoutAddressCard extends StatelessWidget {
  final AddressEntity? address;
  final VoidCallback onChangeAddress;

  const CheckoutAddressCard({super.key, required this.address, required this.onChangeAddress});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final address = this.address;

    if (address != null) {
      return InkWell(
        onTap: onChangeAddress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: brand.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: brand.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(address.summaryLine, style: TextStyle(color: brand.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: brand.textSecondary),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AddressFormScreen())),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: brand.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: brand.accent, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Icon(Icons.add_location_alt_outlined, color: brand.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(strings.addAddressToContinue, style: TextStyle(color: brand.accent)),
            ),
          ],
        ),
      ),
    );
  }
}
