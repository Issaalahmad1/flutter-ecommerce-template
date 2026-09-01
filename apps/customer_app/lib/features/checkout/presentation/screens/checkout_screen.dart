import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/presentation/cubit/address_state.dart';
import '../../../address/presentation/screens/address_form_screen.dart';
import '../../../address/presentation/screens/address_list_screen.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import 'payment_method_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shippingType = 'Economical';

  /// عنوان اختاره المستخدم صراحةً في الجلسة دي (بالضغط على "تغيير") —
  /// لو null، بنستخدم العنوان الافتراضي المحفوظ بتاعه بدلاً منه.
  AddressEntity? _selectedAddress;

  Future<void> _changeAddress() async {
    final picked = await Navigator.of(context).push<AddressEntity>(
      MaterialPageRoute(builder: (_) => const AddressListScreen(isSelecting: true)),
    );
    if (picked != null) setState(() => _selectedAddress = picked);
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.checkoutTitle)),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartLoaded || cartState.items.isEmpty) {
            return Center(child: Text(strings.emptyCart));
          }

          return BlocBuilder<AddressCubit, AddressState>(
            builder: (context, addressState) {
              final address = _selectedAddress ??
                  (addressState is AddressLoaded ? addressState.defaultAddress : null);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.shippingAddress,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (address != null)
                      InkWell(
                        onTap: _changeAddress,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: brand.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: brand.accent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(address.label,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(address.summaryLine,
                                        style: TextStyle(color: brand.textSecondary)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: brand.textSecondary),
                            ],
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AddressFormScreen()),
                        ),
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
                                child: Text(
                                  strings.addAddressToContinue,
                                  style: TextStyle(color: brand.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(strings.chooseShippingType,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...['Economical', 'Express'].map((type) => RadioListTile<String>(
                          value: type,
                          groupValue: _shippingType,
                          onChanged: (value) => setState(() => _shippingType = value!),
                          title: Text(
                            type == 'Economical'
                                ? strings.shippingEconomical
                                : strings.shippingExpress,
                          ),
                          subtitle: Text(type == 'Economical'
                              ? strings.arrivalEconomical
                              : strings.arrivalExpress),
                          activeColor: brand.accent,
                          contentPadding: EdgeInsets.zero,
                        )),
                    const SizedBox(height: 20),
                    Text(strings.orderList, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...cartState.items.map((line) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(child: Text(line.product.name)),
                              Text('x${line.quantity}'),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: address == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PaymentMethodScreen(
                                    address: address,
                                    shippingType: _shippingType,
                                  ),
                                ),
                              );
                            },
                      child: Text(strings.payment),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
