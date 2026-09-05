import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../favourite/presentation/screens/favourite_screen.dart';

/// اختصارات سريعة للمفضلة والسلة — نفس الفكرة موجودة أصلاً في شريط
/// التنقل السفلي، دي بس وصول أسرع من صفحة الحساب مباشرة.
class ProfileQuickActions extends StatelessWidget {
  const ProfileQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _QuickAction(
          icon: Icons.favorite_border,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const FavouriteScreen())),
        ),
        const SizedBox(width: 20),
        _QuickAction(
          icon: Icons.shopping_bag_outlined,
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen())),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: brand.surface, shape: BoxShape.circle),
        child: Icon(icon, color: brand.textPrimary),
      ),
    );
  }
}
