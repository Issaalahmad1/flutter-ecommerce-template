import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_center_state.dart';

/// نفس نمط CartCubit/FavouriteCubit.attachUser بالظبط — بيتفعّل من
/// BlocListener على AuthCubit في main.dart.
class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  final NotificationRepository _notificationRepository;

  String? _uid;
  StreamSubscription<List<NotificationEntity>>? _subscription;

  NotificationCenterCubit({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(const NotificationCenterInitial());

  void attachUser(String? uid) {
    _subscription?.cancel();
    _uid = uid;

    if (uid == null) {
      emit(const NotificationCenterInitial());
      return;
    }

    _subscription = _notificationRepository.watchForUser(uid).listen(
      (notifications) => emit(NotificationCenterLoaded(notifications)),
      onError: (_) => emit(const NotificationCenterError('حدث خطأ في تحميل الإشعارات.')),
    );
  }

  Future<void> markAsRead(String notificationId) {
    final uid = _uid;
    if (uid == null) return Future.value();
    return _notificationRepository.markUserNotificationRead(uid, notificationId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
