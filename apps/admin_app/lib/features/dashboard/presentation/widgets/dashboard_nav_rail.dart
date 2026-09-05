import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/admin_auth_cubit.dart';

class DashboardNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final int unreadNotifications;

  const DashboardNavRail({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.unreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return NavigationRail(
      extended: true,
      minExtendedWidth: 200,
      backgroundColor: brand.surface,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          '${brand.appName} Admin',
          style: TextStyle(color: brand.accent, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign out',
              onPressed: () => context.read<AdminAuthCubit>().signOut(),
            ),
          ),
        ),
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Products'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text('Categories'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Orders'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.view_carousel_outlined),
          selectedIcon: Icon(Icons.view_carousel),
          label: Text('Banners'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.slideshow_outlined),
          selectedIcon: Icon(Icons.slideshow),
          label: Text('Onboarding'),
        ),
        NavigationRailDestination(
          icon: Badge(
            isLabelVisible: unreadNotifications > 0,
            label: Text('$unreadNotifications'),
            child: const Icon(Icons.notifications_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: unreadNotifications > 0,
            label: Text('$unreadNotifications'),
            child: const Icon(Icons.notifications),
          ),
          label: const Text('Notifications'),
        ),
      ],
    );
  }
}
