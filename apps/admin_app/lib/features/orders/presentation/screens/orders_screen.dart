import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/admin_orders_cubit.dart';
import '../cubit/admin_orders_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrdersCubit(orderRepository: OrderRepositoryImpl())..loadOrders(),
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

    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      builder: (context, state) {
        return switch (state) {
          AdminOrdersInitial() || AdminOrdersLoading() =>
            const Center(child: CircularProgressIndicator()),
          AdminOrdersError(:final message) => Center(child: Text(message)),
          AdminOrdersLoaded(:final orders) when orders.isEmpty =>
            const Center(child: Text('لا توجد طلبات حتى الآن.')),
          AdminOrdersLoaded(:final orders) => SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orders', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Order ID')),
                        DataColumn(label: Text('Items')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Payment')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: orders.map((order) {
                        return DataRow(cells: [
                          DataCell(Text('#${order.id.substring(0, 6)}')),
                          DataCell(Text('${order.items.length} items')),
                          DataCell(Text(
                              '${brand.currencySymbol}${order.total.toStringAsFixed(2)}')),
                          DataCell(Text(order.paymentMethod)),
                          DataCell(
                            DropdownButton<OrderStatus>(
                              value: order.status,
                              underline: const SizedBox.shrink(),
                              items: OrderStatus.values
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status.name,
                                          style: TextStyle(
                                            color: _statusColor(status, brand),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  context
                                      .read<AdminOrdersCubit>()
                                      .updateStatus(order, newStatus);
                                }
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
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