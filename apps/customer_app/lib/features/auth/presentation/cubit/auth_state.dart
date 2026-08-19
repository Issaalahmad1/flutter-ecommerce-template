import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

/// كل الحالات الممكنة لشاشات الـ Auth. الشاشة بتستخدم BlocBuilder
/// عشان تعرض واجهة مختلفة حسب الحالة الحالية (راجع قسم 11 في الدليل).
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الافتراضية قبل أي محاولة تسجيل دخول أو تسجيل.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// أثناء تنفيذ طلب لـ Firebase (تسجيل / دخول / تحديث بروفايل).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// نجح تسجيل الدخول أو التسجيل — المستخدم موجود دلوقتي.
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// لا يوجد مستخدم مسجّل دخول حاليًا (بعد Logout أو أول فتح للتطبيق).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// فشلت آخر عملية — الرسالة دي بتتعرض للمستخدم مباشرة (زي كلمة مرور غلط).
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}