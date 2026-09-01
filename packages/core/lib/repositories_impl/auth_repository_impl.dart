import 'package:decoze_core/core.dart';


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
  Future<UserEntity> signInWithGoogle() async {
    final fbUser = await remoteDataSource.signInWithGoogle();

    // لو أول مرة يسجّل بجوجل، مفيش مستند "users/{uid}" ليه لسه —
    // ننشئه بنفس طريقة التسجيل العادي بالإيميل، وناخد الاسم والصورة
    // من حساب جوجل نفسه بدل ما نسيبهم فاضيين.
    var doc = await remoteDataSource.getUserDocument(fbUser.uid);
    if (doc == null) {
      final (firstName, lastName) = _splitDisplayName(fbUser.displayName);
      await remoteDataSource.createUserDocument(
        uid: fbUser.uid,
        email: fbUser.email ?? '',
        firstName: firstName,
        lastName: lastName,
        photoUrl: fbUser.photoURL,
      );
      doc = await remoteDataSource.getUserDocument(fbUser.uid);
    } else {
      doc = await _repairUnsplitName(fbUser.uid, doc, fbUser.displayName);
    }

    final user = UserEntity.fromJson(fbUser.uid, doc ?? {});
    _cachedUser = user;
    return user;
  }
    @override
  Future<UserEntity> signInWithTwitter() async {
    final fbUser = await remoteDataSource.signInWithTwitter();

    // نفس منطق جوجل بالظبط — أول مرة بس بنملأ الاسم والصورة من حساب
    // X، وبعد كده مبنلمسهمش عشان لو المستخدم غيّرهم يدويًا من التطبيق.
    var doc = await remoteDataSource.getUserDocument(fbUser.uid);
    if (doc == null) {
      final (firstName, lastName) = _splitDisplayName(fbUser.displayName);
      await remoteDataSource.createUserDocument(
        uid: fbUser.uid,
        email: fbUser.email ?? '',
        firstName: firstName,
        lastName: lastName,
        photoUrl: fbUser.photoURL,
      );
      doc = await remoteDataSource.getUserDocument(fbUser.uid);
    } else {
      doc = await _repairUnsplitName(fbUser.uid, doc, fbUser.displayName);
    }

    final user = UserEntity.fromJson(fbUser.uid, doc ?? {});
    _cachedUser = user;
    return user;
  }

  /// بيقسّم اسم العرض الراجع من مزوّد تسجيل الدخول (جوجل/X) لاسم أول
  /// واسم أخير — تقسيم بسيط على أول مسافة، كافي لمعظم الحالات.
  (String, String) _splitDisplayName(String? displayName) {
    final trimmed = displayName?.trim() ?? '';
    if (trimmed.isEmpty) return ('', '');
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  /// إصلاح لمرة واحدة لحسابات اتعملت قبل ما نبدأ نقسّم الاسم — لو
  /// firstName لسه فيه مسافة وlastName فاضي (يعني الاسم الكامل اتحط
  /// في الحقل الأول زي ما كان بيحصل في النسخة القديمة)، نعيد التقسيم.
  /// مش هيأثر على حد كتب اسمه الأول فعلاً بدون مسافة.
  Future<Map<String, dynamic>?> _repairUnsplitName(
    String uid,
    Map<String, dynamic> doc,
    String? displayName,
  ) async {
    final currentFirstName = doc['firstName'] as String? ?? '';
    final currentLastName = doc['lastName'] as String? ?? '';
    if (currentLastName.isNotEmpty || !currentFirstName.contains(' ')) {
      return doc;
    }

    final (firstName, lastName) = _splitDisplayName(displayName ?? currentFirstName);
    if (firstName.isEmpty || lastName.isEmpty) return doc;

    await remoteDataSource.updateUserDocument(uid, {
      'firstName': firstName,
      'lastName': lastName,
    });
    return remoteDataSource.getUserDocument(uid);
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
    String? photoUrl,
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
      'photoUrl': ?photoUrl,
    });
    final doc = await remoteDataSource.getUserDocument(uid);
    if (doc != null) {
      _cachedUser = UserEntity.fromJson(uid, doc);
    }
  }
}