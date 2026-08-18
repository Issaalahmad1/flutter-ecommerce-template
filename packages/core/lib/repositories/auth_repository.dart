import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChanges();

  UserEntity? get currentUser;

  Future<UserEntity> signUp({
    required String email,
    required String password,
  });

  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dob,
    String? gender,
  });
}
