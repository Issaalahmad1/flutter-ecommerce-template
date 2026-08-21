import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // عنوان مؤقت ثابت — شاشة "إضافة/تعديل عنوان" لسه من الفجوات الموثقة
  // في قسم 05 من الدليل، هنبنيها كـ feature منفصل بعدين.
  static const _defaultAddress = AddressEntity(
    id: 'default',
    label: 'Home',
    addressLine: 'House 05, Road 13, Nikhunjo 2',
    city: 'Dhaka',
    isDefault: true,
  );

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded || state.items.isEmpty) {
            return const Center(child: Text('السلة فاضية.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
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
                            Text(_defaultAddress.label,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${_defaultAddress.addressLine}, ${_defaultAddress.city}',
                                style: TextStyle(color: brand.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Choose Shipping Type', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...['Economical', 'Express'].map((type) => RadioListTile<String>(
                      value: type,
                      groupValue: _shippingType,
                      onChanged: (value) => setState(() => _shippingType = value!),
                      title: Text(type),
                      subtitle: Text(type == 'Economical'
                          ? 'Estimated arrival: 5-7 days'
                          : 'Estimated arrival: 1-2 days'),
                      activeColor: brand.accent,
                      contentPadding: EdgeInsets.zero,
                    )),
                const SizedBox(height: 20),
                Text('Order List', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...state.items.map((line) => Padding(
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodScreen(
                          address: _defaultAddress,
                          shippingType: _shippingType,
                        ),
                      ),
                    );
                  },
                  child: const Text('Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}