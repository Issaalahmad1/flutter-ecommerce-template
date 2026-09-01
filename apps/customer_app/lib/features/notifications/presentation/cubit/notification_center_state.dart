import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class NotificationCenterState extends Equatable {
  const NotificationCenterState();

  @override
  List<Object?> get props => [];
}

class NotificationCenterInitial extends NotificationCenterState {
  const NotificationCenterInitial();
}

class NotificationCenterLoaded extends NotificationCenterState {
  final List<NotificationEntity> notifications;

  const NotificationCenterLoaded(this.notifications);

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  List<Object?> get props => [notifications];
}

class NotificationCenterError extends NotificationCenterState {
  final String message;
  const NotificationCenterError(this.message);

  @override
  List<Object?> get props => [message];
}
