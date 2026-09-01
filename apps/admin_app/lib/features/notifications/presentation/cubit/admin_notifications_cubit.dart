import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_notifications_state.dart';

/// على عكس نظيره في customer_app، مفيش attachUser هنا — إشعارات
/// الأدمن مش مرتبطة بمستخدم معيّن، أي حساب أدمن داخل على الداشبورد
/// بيشوف نفس القائمة، فبنبدأ الاستماع فورًا.
class AdminNotificationsCubit extends Cubit<AdminNotificationsState> {
  final NotificationRepository _notificationRepository;
  StreamSubscription<List<NotificationEntity>>? _subscription;

  AdminNotificationsCubit({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const AdminNotificationsInitial()) {
    _subscription = _notificationRepository.watchForAdmin().listen(
      (notifications) => emit(AdminNotificationsLoaded(notifications)),
      onError: (_) => emit(const AdminNotificationsError('Failed to load notifications.')),
    );
  }

  Future<void> markAsRead(String notificationId) {
    return _notificationRepository.markAdminNotificationRead(notificationId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
