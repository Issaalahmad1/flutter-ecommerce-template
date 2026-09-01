import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  StreamSubscription<UserEntity?>? _authSubscription;

  /// بيتنفذ مرة واحدة عند بداية التطبيق — بيراقب authStateChanges()
  /// من Firebase طول الوقت، فلو المستخدم مسجّل دخول من قبل (Session
  /// محفوظة)، الـ Cubit هيعرف من غير ما نطلب منه إحنا يدويًا.
  void listenToAuthChanges() {
    _authSubscription = _authRepository.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signUp(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      debugPrint('== Sign up error: $e ==');
      emit(AuthError(_readableError(e)));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signIn(email: email, password: password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      debugPrint('== Sign in error: $e ==');
      emit(AuthError(_readableError(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      debugPrint('== Google sign in error: $e ==');
      emit(AuthError(e is StateError ? e.message : 'حدث خطأ غير متوقع.'));
    }
  }

    Future<void> signInWithTwitter() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithTwitter();
      emit(AuthAuthenticated(user));
    } catch (e) {
      debugPrint('== Twitter sign in error: $e ==');
      emit(AuthError(e is StateError ? e.message : 'حدث خطأ غير متوقع.'));
    }
  }
  /// بيحدّث بيانات البروفايل (الاسم، الصورة، تاريخ الميلاد...) لحساب
  /// المستخدم الحالي. الإيميل مش من ضمن الحقول القابلة للتعديل هنا —
  /// تغيير الإيميل في Firebase Auth عملية حساسة محتاجة إعادة تحقق
  /// منفصلة، مش جزء من الشاشة دي.
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dob,
    String? gender,
    String? photoUrl,
  }) async {
    try {
      await _authRepository.completeProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        dob: dob,
        gender: gender,
        photoUrl: photoUrl,
      );
      final updatedUser = _authRepository.currentUser;
      if (updatedUser != null) {
        emit(AuthAuthenticated(updatedUser));
      }
    } catch (e) {
      debugPrint('== Update profile error: $e ==');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

  Future<void> sendPasswordReset(String email) async {
    emit(const AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(_readableError(e)));
    }
  }

  /// بيحوّل أكواد أخطاء Firebase (زي "wrong-password") لرسائل عربية
  /// مفهومة للمستخدم، بدل ما يشوف رسالة تقنية إنجليزية غريبة.
  String _readableError(Object error) {
    if (error is fb_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'البريد الإلكتروني ده مستخدم بالفعل.';
        case 'invalid-email':
          return 'صيغة البريد الإلكتروني غير صحيحة.';
        case 'weak-password':
          return 'كلمة المرور ضعيفة، لازم تكون 6 أحرف على الأقل.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
        default:
          return 'حدث خطأ، حاول مرة أخرى.';
      }
    }
    return 'حدث خطأ غير متوقع، حاول مرة أخرى.';
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}