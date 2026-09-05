import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../category/presentation/screens/categories_overview_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../widgets/animated_gradient_ring.dart';
import '../widgets/nav_item.dart';

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
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onSelect: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _BottomNavBar({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Container(
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
            NavItem(
              icon: "assets/bottom_navigation_bar_icon/Home Angle 3.png",
              label: strings.navHome,
              isActive: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
            NavItem(
              icon: "assets/bottom_navigation_bar_icon/Widget.png",
              label: strings.navCategory,
              isActive: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
            NavItem(
              icon: "assets/bottom_navigation_bar_icon/Bag.png",
              label: strings.navCart,
              isActive: selectedIndex == 2,
              onTap: () => onSelect(2),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final photoUrl =
                    authState is AuthAuthenticated ? authState.user.photoUrl : null;
                return NavItem(
                  icon: "assets/bottom_navigation_bar_icon/User Rounded.png",
                  // لو المستخدم عنده صورة بروفايل، بتتحط بدل الأيقونة
                  // الافتراضية — بإطار متدرّج بيلف حواليها لما التاب يبقى
                  // مفعّل (راجع AnimatedGradientRing).
                  customIcon: photoUrl == null
                      ? null
                      : AnimatedGradientRing(
                          isActive: selectedIndex == 3,
                          child: CircleAvatar(radius: 12, backgroundImage: NetworkImage(photoUrl)),
                        ),
                  label: strings.navProfile,
                  isActive: selectedIndex == 3,
                  onTap: () => onSelect(3),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
