import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AdminAuthState extends Equatable {
  const AdminAuthState();

  @override
  List<Object?> get props => [];
}

class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading();
}

class AdminAuthAuthenticated extends AdminAuthState {
  final UserEntity user;
  const AdminAuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AdminAuthUnauthenticated extends AdminAuthState {
  const AdminAuthUnauthenticated();
}

/// حالة خاصة بلوحة الأدمن بس — البريد وكلمة المرور صحيحين، لكن
/// الحساب مش عنده صلاحية أدمن. لازم نميّزها عن AuthError العادية
/// عشان نعرض رسالة واضحة ("الحساب ده مش أدمن") بدل "بيانات خاطئة".
class AdminAuthUnauthorized extends AdminAuthState {
  const AdminAuthUnauthorized();
}

class AdminAuthError extends AdminAuthState {
  final String message;
  const AdminAuthError(this.message);

  @override
  List<Object?> get props => [message];
}