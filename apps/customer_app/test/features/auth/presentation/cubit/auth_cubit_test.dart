import 'package:bloc_test/bloc_test.dart';
import 'package:decoze_core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_state.dart';

/// نسخة وهمية من AuthRepository — بنتحكم إحنا في ردودها بالكامل،
/// من غير أي اتصال حقيقي بـ Firebase.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  final testUser = UserEntity(
    uid: 'uid123',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    createdAt: DateTime(2026, 1, 1),
  );

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'يصدر [AuthLoading, AuthAuthenticated] لما تسجيل الدخول ينجح',
      build: () {
        when(() => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => testUser);
        return AuthCubit(authRepository);
      },
      act: (cubit) => cubit.signIn(email: 'test@example.com', password: '123456'),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'يصدر [AuthLoading, AuthError] برسالة عربية لما كلمة المرور غلط',
      build: () {
        when(() => authRepository.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(FirebaseAuthException(code: 'wrong-password'));
        return AuthCubit(authRepository);
      },
      act: (cubit) => cubit.signIn(email: 'test@example.com', password: 'wrong'),
      expect: () => [
        const AuthLoading(),
        const AuthError('البريد الإلكتروني أو كلمة المرور غير صحيحة.'),
      ],
    );
  });
}