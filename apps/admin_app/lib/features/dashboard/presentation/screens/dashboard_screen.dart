import 'package:admin_app/features/banners/presentation/screens/banners_screen.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/admin_auth_cubit.dart';
import '../../../categories/presentation/screens/categories_screen.dart';
import '../../../notifications/presentation/cubit/admin_notifications_cubit.dart';
import '../../../notifications/presentation/cubit/admin_notifications_state.dart';
import '../../../notifications/presentation/screens/admin_notifications_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

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
    _DashboardHomeTab(),
    ProductsScreen(),
    CategoriesScreen(),
    OrdersScreen(),
    BannersScreen(),
    AdminNotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final unreadCount = context.select<AdminNotificationsCubit, int>((cubit) {
      final state = cubit.state;
      return state is AdminNotificationsLoaded ? state.unreadCount : 0;
    });

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 200,
            backgroundColor: brand.surface,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                '${brand.appName} Admin',
                style: TextStyle(
                  color: brand.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
              NavigationRailDestination(
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  child: const Icon(Icons.notifications_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text('$unreadCount'),
                  child: const Icon(Icons.notifications),
                ),
                label: const Text('Notifications'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _tabs),
          ),
        ],
      ),
    );
  }
}

class _DashboardHomeTab extends StatefulWidget {
  const _DashboardHomeTab();

  @override
  State<_DashboardHomeTab> createState() => _DashboardHomeTabState();
}

class _DashboardHomeTabState extends State<_DashboardHomeTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        orderRepository: OrderRepositoryImpl(),
        productRepository: ProductRepositoryImpl(),
      )..loadDashboard(),
      child: const _DashboardHomeBody(),
    );
  }
}

class _DashboardHomeBody extends StatelessWidget {
  const _DashboardHomeBody();

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return switch (state) {
          DashboardInitial() || DashboardLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          DashboardError(:final message) => Center(child: Text(message)),
          DashboardLoaded(
            :final totalRevenue,
            :final totalOrders,
            :final totalProducts,
            :final recentOrders,
          ) =>
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _StatCard(
                        label: 'Revenue',
                        value:
                            '${brand.currencySymbol}${totalRevenue.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Orders', value: '$totalOrders'),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Products', value: '$totalProducts'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recent orders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (recentOrders.isEmpty)
                    const Text('لا توجد طلبات حتى الآن.')
                  else
                    ...recentOrders.map(
                      (order) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Order #${order.id.substring(0, 6)}'),
                        subtitle: Text(order.status.name),
                        trailing: Text(
                          '${brand.currencySymbol}${order.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: brand.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        };
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: brand.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: brand.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
