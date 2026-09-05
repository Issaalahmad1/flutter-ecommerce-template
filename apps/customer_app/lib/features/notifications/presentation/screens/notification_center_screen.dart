import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../order/presentation/screens/track_order_screen.dart';
import '../cubit/notification_center_cubit.dart';
import '../cubit/notification_center_state.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: Text(strings.notificationsTitle)),
      body: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
        builder: (context, state) {
          if (state is! NotificationCenterLoaded ||
              state.notifications.isEmpty) {
            return Center(
              child: Text(
                strings.noNotificationsYet,
                style: TextStyle(color: brand.textSecondary),
              ),
            );
          }

          return ResponsiveContent(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;

  const _NotificationTile({required this.notification});

  (String title, String body, String? orderId) _content(AppStrings strings) {
    switch (notification.type) {
      case NotificationType.orderStatusChanged:
        final orderId = notification.data['orderId'] as String? ?? '';
        final status = notification.data['status'] as String? ?? '';
        return (
          strings.notifOrderStatusTitle,
          strings.notifOrderStatusBody(orderId, status),
          orderId,
        );
      case NotificationType.newOrder:
        // نوع خاص بإشعارات الأدمن — مش المفروض يظهر للعميل، بس بنغطيه
        // احتياطًا عشان الـ switch يفضل شامل.
        return (strings.notifNewOrderTitle, '', null);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final (title, body, orderId) = _content(strings);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationCenterCubit>().markAsRead(notification.id);
        }
        if (orderId != null && orderId.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TrackOrderScreen(orderId: orderId),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: brand.surface,
          borderRadius: BorderRadius.circular(14),
          border: notification.isRead
              ? null
              : Border.all(color: brand.accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(top: 6, left: 4, right: 8),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: brand.accent,
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(body, style: TextStyle(color: brand.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
