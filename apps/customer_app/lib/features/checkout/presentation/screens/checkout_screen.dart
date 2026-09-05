import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../address/presentation/cubit/address_cubit.dart';
import '../../../address/presentation/cubit/address_state.dart';
import '../../../address/presentation/screens/address_list_screen.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../widgets/checkout_address_card.dart';
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
      MaterialPageRoute(
        builder: (_) => const AddressListScreen(isSelecting: true),
      ),
    );
    if (picked != null) setState(() => _selectedAddress = picked);
  }

  @override
  Widget build(BuildContext context) {
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
              final address =
                  _selectedAddress ??
                  (addressState is AddressLoaded
                      ? addressState.defaultAddress
                      : null);

              return SingleChildScrollView(
                child: ResponsiveContent(
                  child: _CheckoutForm(
                    address: address,
                    onChangeAddress: _changeAddress,
                    shippingType: _shippingType,
                    onShippingTypeChanged: (value) =>
                        setState(() => _shippingType = value),
                    cartState: cartState,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget {
  final AddressEntity? address;
  final VoidCallback onChangeAddress;
  final String shippingType;
  final ValueChanged<String> onShippingTypeChanged;
  final CartLoaded cartState;

  const _CheckoutForm({
    required this.address,
    required this.onChangeAddress,
    required this.shippingType,
    required this.onShippingTypeChanged,
    required this.cartState,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.shippingAddress,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          CheckoutAddressCard(
            address: address,
            onChangeAddress: onChangeAddress,
          ),
          const SizedBox(height: 20),
          Text(
            strings.chooseShippingType,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...['Economical', 'Express'].map(
            (type) => RadioListTile<String>(
              value: type,
              groupValue: shippingType,
              onChanged: (value) => onShippingTypeChanged(value!),
              title: Text(
                type == 'Economical'
                    ? strings.shippingEconomical
                    : strings.shippingExpress,
              ),
              subtitle: Text(
                type == 'Economical'
                    ? strings.arrivalEconomical
                    : strings.arrivalExpress,
              ),
              activeColor: BrandConfig.decoze.accent,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            strings.orderList,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...cartState.items.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(line.product.name)),
                  Text('x${line.quantity}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: address == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodScreen(
                          address: address!,
                          shippingType: shippingType,
                        ),
                      ),
                    );
                  },
            child: Text(strings.payment),
          ),
        ],
      ),
    );
  }
}
