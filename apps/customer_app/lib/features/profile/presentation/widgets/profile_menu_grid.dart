import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../address/presentation/screens/address_list_screen.dart';
import '../../../order/presentation/screens/orders_screen.dart';
import '../../../settings/presentation/screens/notifications_screen.dart';
import '../../../settings/presentation/screens/payment_methods_screen.dart';
import '../../../settings/presentation/screens/security_screen.dart';

/// شبكة 2×2(+1) من الروابط — الطلبات، طرق الدفع، العناوين، إعدادات
/// الإشعارات، والأمان — كلهم جوّه كارت واحد زي التصميم.
class ProfileMenuGrid extends StatelessWidget {
  const ProfileMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: brand.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MenuLink(
                  label: strings.ordersTitle,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const OrdersScreen())),
                ),
              ),
              Expanded(
                child: _MenuLink(
                  label: strings.paymentMethodsTitle,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MenuLink(
                  label: strings.addressesTitle,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const AddressListScreen())),
                ),
              ),
              Expanded(
                child: _MenuLink(
                  label: strings.notificationsTitle,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MenuLink(
                  label: strings.securityTitle,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SecurityScreen())),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

/// رابط نصي بس (من غير أيقونة) — بيتحط جوّه شبكة 2×2 داخل كارت واحد،
/// زي التصميم بالظبط.
class _MenuLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: brand.textPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
