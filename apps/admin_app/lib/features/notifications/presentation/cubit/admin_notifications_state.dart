import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AdminNotificationsState extends Equatable {
  const AdminNotificationsState();

  @override
  List<Object?> get props => [];
}

class AdminNotificationsInitial extends AdminNotificationsState {
  const AdminNotificationsInitial();
}

class AdminNotificationsLoaded extends AdminNotificationsState {
  final List<NotificationEntity> notifications;

  const AdminNotificationsLoaded(this.notifications);

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  List<Object?> get props => [notifications];
}

class AdminNotificationsError extends AdminNotificationsState {
  final String message;
  const AdminNotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
