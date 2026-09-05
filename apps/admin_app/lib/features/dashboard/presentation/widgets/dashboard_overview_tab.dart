import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'stat_card.dart';

/// تاب "Dashboard" الأول — إحصائيات سريعة + آخر 5 طلبات.
class DashboardOverviewTab extends StatelessWidget {
  const DashboardOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        orderRepository: OrderRepositoryImpl(),
        productRepository: ProductRepositoryImpl(),
      )..loadDashboard(),
      child: const _DashboardOverviewBody(),
    );
  }
}

class _DashboardOverviewBody extends StatelessWidget {
  const _DashboardOverviewBody();

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
                  Text('Overview', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      StatCard(
                        label: 'Revenue',
                        value: '${brand.currencySymbol}${totalRevenue.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 12),
                      StatCard(label: 'Orders', value: '$totalOrders'),
                      const SizedBox(width: 12),
                      StatCard(label: 'Products', value: '$totalProducts'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Recent orders', style: Theme.of(context).textTheme.titleMedium),
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
                          style: TextStyle(color: brand.accent, fontWeight: FontWeight.bold),
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
