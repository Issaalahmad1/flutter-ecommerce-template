import 'package:decoze_core/core.dart';

import '../datasources/auth_remote_datasource.dart';

/// التنفيذ الفعلي لـ AuthRepository (الـ interface المعرّف في decoze_core).
/// هنا بس بنحوّل بين كائنات Firebase الخام وبين UserEntity بتاعنا —
/// أي Cubit بيستخدم الكلاس ده مبيعرفش إن Firebase موجود من الأساس.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  /// آخر UserEntity معروف — بيتحدّث تلقائي مع كل حدث من authStateChanges،
  /// وده اللي بيخلي getter الـ currentUser يشتغل من غير ما يحتاج ينتظر
  /// نداء Firestore جديد كل مرة.
  UserEntity? _cachedUser;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Stream<UserEntity?> authStateChanges() {
    return remoteDataSource.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) {
        _cachedUser = null;
        return null;
      }
      final doc = await remoteDataSource.getUserDocument(fbUser.uid);
      if (doc == null) {
        _cachedUser = null;
        return null;
      }
      final user = UserEntity.fromJson(fbUser.uid, doc);
      _cachedUser = user;
      return user;
    });
  }

  @override
  UserEntity? get currentUser => _cachedUser;

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final fbUser = await remoteDataSource.signUpWithEmail(email, password);
    await remoteDataSource.createUserDocument(uid: fbUser.uid, email: email);
    final doc = await remoteDataSource.getUserDocument(fbUser.uid);
    final user = UserEntity.fromJson(fbUser.uid, doc ?? {});
    _cachedUser = user;
    return user;
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final fbUser = await remoteDataSource.signInWithEmail(email, password);
    final doc = await remoteDataSource.getUserDocument(fbUser.uid);
    final user = UserEntity.fromJson(fbUser.uid, doc ?? {});
    _cachedUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
    _cachedUser = null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dob,
    String? gender,
  }) async {
    final uid = _cachedUser?.uid;
    if (uid == null) {
      throw StateError('لا يوجد مستخدم مسجّل دخول حاليًا.');
    }
    await remoteDataSource.updateUserDocument(uid, {
      'firstName': firstName,
      'lastName': lastName,
      'phone': ?phone,
      if (dob != null) 'dob': dob.toIso8601String(),
      'gender': ?gender,
    });
    final doc = await remoteDataSource.getUserDocument(uid);
    if (doc != null) {
      _cachedUser = UserEntity.fromJson(uid, doc);
    }
  }
}