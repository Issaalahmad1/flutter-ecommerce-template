import 'package:admin_app/features/banners/presentation/screens/banners_screen.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../categories/presentation/screens/categories_screen.dart';
import '../../../notifications/presentation/cubit/admin_notifications_cubit.dart';
import '../../../notifications/presentation/cubit/admin_notifications_state.dart';
import '../../../notifications/presentation/screens/admin_notifications_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_slides_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../widgets/dashboard_nav_rail.dart';
import '../widgets/dashboard_overview_tab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdminNotificationsCubit(notificationRepository: NotificationRepositoryImpl()),
      child: const _DashboardScreenBody(),
    );
  }
}

class _DashboardScreenBody extends StatefulWidget {
  const _DashboardScreenBody();

  @override
  State<_DashboardScreenBody> createState() => _DashboardScreenBodyState();
}

class _DashboardScreenBodyState extends State<_DashboardScreenBody> {
  int _selectedIndex = 0;

  static const _tabs = [
    DashboardOverviewTab(),
    ProductsScreen(),
    CategoriesScreen(),
    OrdersScreen(),
    BannersScreen(),
    OnboardingSlidesScreen(),
    AdminNotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.select<AdminNotificationsCubit, int>((cubit) {
      final state = cubit.state;
      return state is AdminNotificationsLoaded ? state.unreadCount : 0;
    });

    return Scaffold(
      body: Row(
        children: [
          DashboardNavRail(
            selectedIndex: _selectedIndex,
            onSelect: (index) => setState(() => _selectedIndex = index),
            unreadNotifications: unreadCount,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: IndexedStack(index: _selectedIndex, children: _tabs)),
        ],
      ),
    );
  }
}
