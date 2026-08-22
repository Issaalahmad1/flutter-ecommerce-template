import 'package:decoze_core/core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_auth_state.dart';

class AdminAuthCubit extends Cubit<AdminAuthState> {
  final AuthRepository _authRepository;

  AdminAuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AdminAuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(const AdminAuthLoading());
    try {
      final user = await _authRepository.signIn(email: email, password: password);

      // فحص الصلاحية — نفس الـ UserEntity من decoze_core، لكن هنا
      // بنتأكد صراحة إن role == admin قبل ما نسمح بالدخول للوحة.
      if (!user.isAdmin) {
        await _authRepository.signOut();
        emit(const AdminAuthUnauthorized());
        return;
      }

      emit(AdminAuthAuthenticated(user));
    } catch (e) {
      emit(AdminAuthError(_readableError(e)));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const AdminAuthUnauthenticated());
  }

  String _readableError(Object error) {
    if (error is fb_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
        case 'invalid-email':
          return 'صيغة البريد الإلكتروني غير صحيحة.';
        default:
          return 'حدث خطأ، حاول مرة أخرى.';
      }
    }
    return 'حدث خطأ غير متوقع.';
  }
}