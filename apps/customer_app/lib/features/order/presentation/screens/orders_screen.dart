import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/orders_list_cubit.dart';
import '../cubit/orders_list_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final uid = authState is AuthAuthenticated ? authState.user.uid : '';

    return BlocProvider(
      create: (_) =>
          OrdersListCubit(orderRepository: OrderRepositoryImpl())
            ..loadOrders(uid),
      child: const _OrdersScreenBody(),
    );
  }
}

class _OrdersScreenBody extends StatelessWidget {
  const _OrdersScreenBody();

  Color _statusColor(OrderStatus status, BrandConfig brand) {
    return switch (status) {
      OrderStatus.delivered => Colors.green,
      OrderStatus.canceled => Colors.red,
      OrderStatus.shipped => brand.accent,
      OrderStatus.processing || OrderStatus.pending => Colors.orange,
    };
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.ordersTitle)),
      body: BlocBuilder<OrdersListCubit, OrdersListState>(
        builder: (context, state) {
          return switch (state) {
            OrdersListInitial() || OrdersListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            OrdersListError(:final message) => Center(child: Text(message)),
            OrdersListLoaded(:final orders) when orders.isEmpty => Center(
              child: Text(strings.noOrders),
            ),
            OrdersListLoaded(:final orders) => ResponsiveContent(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final firstItem = order.items.isNotEmpty
                      ? order.items.first
                      : null;

                  return Row(
                    children: [
                      if (firstItem != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            firstItem.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.status.name[0].toUpperCase() +
                                  order.status.name.substring(1),
                              style: TextStyle(
                                color: _statusColor(order.status, brand),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              firstItem?.name ?? 'Order #${order.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${brand.currencySymbol} ${order.total.toStringAsFixed(2)}',
                              style: TextStyle(color: brand.accent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          };
        },
      ),
    );
  }
}
