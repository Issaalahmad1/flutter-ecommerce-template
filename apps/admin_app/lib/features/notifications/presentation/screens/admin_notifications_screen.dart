import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/admin_notifications_cubit.dart';
import '../cubit/admin_notifications_state.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return BlocBuilder<AdminNotificationsCubit, AdminNotificationsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              if (state is! AdminNotificationsLoaded || state.notifications.isEmpty)
                Text(
                  'No notifications yet.',
                  style: TextStyle(color: brand.textSecondary),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      final customerName = notification.data['customerName'] as String? ?? '';
                      final total = (notification.data['total'] as num?)?.toDouble() ?? 0;

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (!notification.isRead) {
                            context.read<AdminNotificationsCubit>().markAsRead(notification.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: brand.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: notification.isRead
                                ? null
                                : Border.all(color: brand.accent.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              if (!notification.isRead)
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 8,
                                  height: 8,
                                  decoration:
                                      BoxDecoration(color: brand.accent, shape: BoxShape.circle),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'New order',
                                      style: TextStyle(
                                        fontWeight:
                                            notification.isRead ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'From $customerName — ${brand.currencySymbol}${total.toStringAsFixed(2)}',
                                      style: TextStyle(color: brand.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
