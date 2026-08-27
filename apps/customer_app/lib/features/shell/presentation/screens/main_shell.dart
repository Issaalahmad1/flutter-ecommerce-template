import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../category/presentation/screens/categories_overview_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// الحاوية الرئيسية للتطبيق بعد تسجيل الدخول — بتحافظ على حالة كل تاب
/// (IndexedStack) بدل ما تعيد بناءه من الصفر كل مرة تبدّل بينهم.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    HomeScreen(),
    CategoriesOverviewScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: brand.primaryBackground,
          border: Border(top: BorderSide(color: brand.surface, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/Home Angle 3.png",
                label: 'Home',
                isActive: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/Widget.png",
                label: 'Category',
                isActive: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/Bag.png",
                label: 'Cart',
                isActive: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/User Rounded.png",
                label: 'Profile',
                isActive: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return GestureDetector(
      onTap: () {
        SystemSound.play(SystemSoundType.click);

        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon,
              height: 24,
              width: 24,
              color: isActive ? brand.accent : brand.textSecondary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? brand.accent : brand.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
