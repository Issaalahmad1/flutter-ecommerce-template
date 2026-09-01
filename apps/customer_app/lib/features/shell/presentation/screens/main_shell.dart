import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
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
    final strings = context.strings;

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
                label: strings.navHome,
                isActive: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/Widget.png",
                label: strings.navCategory,
                isActive: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _NavItem(
                icon: "assets/bottom_navigation_bar_icon/Bag.png",
                label: strings.navCart,
                isActive: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final photoUrl = authState is AuthAuthenticated
                      ? authState.user.photoUrl
                      : null;
                  return _NavItem(
                    icon: "assets/bottom_navigation_bar_icon/User Rounded.png",
                    // لو المستخدم عنده صورة بروفايل، بتتحط بدل الأيقونة
                    // الافتراضية — نفس فكرة تطبيقات زي إنستجرام وتيك توك،
                    // بإطار متدرّج (أصفر↔رمادي) بيلف حواليها لما التاب يبقى
                    // مفعّل، قريب من حركة الـ Story Ring بتاعة إنستجرام.
                    customIcon: photoUrl == null
                        ? null
                        : _AnimatedGradientRing(
                            isActive: _selectedIndex == 3,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                          ),
                    label: strings.navProfile,
                    isActive: _selectedIndex == 3,
                    onTap: () => setState(() => _selectedIndex = 3),
                  );
                },
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
  /// لو موجودة، بتترسم بدل الأيقونة الافتراضية (زي صورة البروفايل).
  final Widget? customIcon;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.customIcon,
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
            padding: EdgeInsets.all(customIcon == null ? 8 : 3),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            // customIcon (زي إطار صورة البروفايل المتحرّك) بيدير مظهره
            // وإطاره بنفسه — من غير ما نلفّه بحدود تانية هنا.
            child: customIcon ??
                Image.asset(
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

/// إطار متدرّج (أصفر↔رمادي) بيلف حوالين صورة البروفايل ويدور باستمرار
/// لما التاب يبقى مفعّل — قريب من حركة "Story Ring" بتاعة إنستجرام،
/// بس بألوان البراند بدل قوس قزح إنستجرام. لما التاب مش مفعّل، بيفضل
/// إطار رمادي ثابت من غير حركة.
class _AnimatedGradientRing extends StatefulWidget {
  final Widget child;
  final bool isActive;

  const _AnimatedGradientRing({required this.child, required this.isActive});

  @override
  State<_AnimatedGradientRing> createState() => _AnimatedGradientRingState();
}

class _AnimatedGradientRingState extends State<_AnimatedGradientRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    if (!widget.isActive) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: brand.textSecondary.withValues(alpha: 0.5)),
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              transform: GradientRotation(_controller.value * 6.2832),
              colors: [
                brand.accent,
                brand.textSecondary,
                brand.accent,
                brand.textSecondary,
                brand.accent,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
