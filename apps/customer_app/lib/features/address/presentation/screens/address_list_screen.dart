import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';
import 'address_form_screen.dart';

/// شاشة إدارة العناوين — لو المستخدم بيختار عنوان للشحن (مش بس بيدير
/// عناوينه من صفحة الحساب)، بنمرّر [isSelecting] عشان الضغط على أي
/// عنوان يرجّعه للشاشة اللي فاتحة دي (زي شاشة الدفع) بدل ما يفتح تعديل.
class AddressListScreen extends StatelessWidget {
  final bool isSelecting;

  const AddressListScreen({super.key, this.isSelecting = false});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelecting ? strings.selectAddress : strings.addressesTitle),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is! AddressLoaded || state.addresses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  strings.noAddressesYet,
                  style: TextStyle(color: brand.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.addresses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return _AddressCard(
                address: address,
                isSelecting: isSelecting,
                onTap: isSelecting ? () => Navigator.of(context).pop(address) : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddressFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(strings.addAddress),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final bool isSelecting;
  final VoidCallback? onTap;

  const _AddressCard({required this.address, required this.isSelecting, this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: brand.surface,
          borderRadius: BorderRadius.circular(14),
          border: address.isDefault ? Border.all(color: brand.accent, width: 1.5) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: brand.accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: brand.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      strings.defaultLabel,
                      style: TextStyle(
                        color: brand.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(address.fullName, style: TextStyle(color: brand.textSecondary)),
            Text(address.summaryLine, style: TextStyle(color: brand.textSecondary)),
            Text(address.phone, style: TextStyle(color: brand.textSecondary)),
            if (!isSelecting) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!address.isDefault)
                    TextButton(
                      onPressed: () =>
                          context.read<AddressCubit>().setDefaultAddress(address.id),
                      child: Text(strings.setAsDefault),
                    ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddressFormScreen(existing: address),
                      ),
                    ),
                    child: Text(strings.editAddress),
                  ),
                  TextButton(
                    onPressed: () => _confirmDelete(context, address.id),
                    child: Text(
                      strings.deleteAddress,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String addressId) {
    final strings = context.strings;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.confirmDeleteAddress),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AddressCubit>().deleteAddress(addressId);
            },
            child: Text(strings.deleteAddress, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
