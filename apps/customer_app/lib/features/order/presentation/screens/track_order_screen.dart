import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderCubit(orderRepository: OrderRepositoryImpl())
            ..loadOrder(orderId),
      child: const _TrackOrderBody(),
    );
  }
}

class _TrackOrderBody extends StatelessWidget {
  const _TrackOrderBody();

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return switch (state) {
            OrderInitial() || OrderProcessing() => const Center(
              child: CircularProgressIndicator(),
            ),
            OrderError(:final message) => Center(child: Text(message)),
            OrderReady(:final order) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: brand.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: brand.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Delivery',
                        style: TextStyle(color: brand.textSecondary),
                      ),
                      const Text(
                        '48 Hours',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...order.trackingSteps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            step.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: step.isCompleted
                                ? brand.accent
                                : brand.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.title,
                              style: TextStyle(
                                color: step.isCompleted
                                    ? brand.textPrimary
                                    : brand.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      });
                    },
                    child: const Text('Back To Home'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
