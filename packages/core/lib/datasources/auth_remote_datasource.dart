import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// الطبقة الوحيدة في المشروع اللي بتكلم Firebase SDK مباشرة لأي حاجة
/// خاصة بالـ Auth. الـ Repository (في data/repositories) بيستخدمها
/// وبيحوّل نتايجها لـ UserEntity، بدل ما يتكلم مع Firebase بنفسه.
class AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  Stream<fb_auth.User?> authStateChanges() => firebaseAuth.authStateChanges();

  Future<fb_auth.User> signUpWithEmail(String email, String password) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('فشل إنشاء الحساب.');
    }
    return user;
  }

  Future<fb_auth.User> signInWithEmail(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('فشل تسجيل الدخول.');
    }
    return user;
  }

  bool _googleSignInInitialized = false;

  /// الإصدار الحديث من المكتبة (7.x) بيحتاج نداء "تهيئة" مرة واحدة بس
  /// قبل أي استخدام. الـ flag ده بيضمن إننا منناديهاش أكتر من مرة بالغلط.
  Future<void> _ensureGoogleSignInInitialized() async {
  if (_googleSignInInitialized) return;
  await GoogleSignIn.instance.initialize(
    serverClientId:
        'REDACTED-GOOGLE-SIGNIN-CLIENT-ID',
  );
  _googleSignInInitialized = true;
}

  Future<fb_auth.User> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

        final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      debugPrint('== GoogleSignInException code: ${e.code} ==');
      debugPrint('== GoogleSignInException description: ${e.description} ==');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw StateError('تم إلغاء تسجيل الدخول.');
      }
      throw StateError('حدث خطأ أثناء تسجيل الدخول بجوجل.');
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw StateError('تعذر الحصول على بيانات جوجل.');
    }

    final credential = fb_auth.GoogleAuthProvider.credential(idToken: idToken);

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw StateError('فشل تسجيل الدخول بجوجل.');
    }
    return user;
  }

      Future<fb_auth.User> signInWithTwitter() async {
    final twitterProvider = fb_auth.TwitterAuthProvider();
    final userCredential = await firebaseAuth.signInWithProvider(twitterProvider);
    final user = userCredential.user;
    if (user == null) {
      throw StateError('فشل تسجيل الدخول بـ X.');
    }

    // X مش بيرجّع بريد إلكتروني إلا لو التطبيق فعّل "Request email"
    // (محتاج Privacy Policy رسمي). لحد ما نضيفها، بنستخدم اسم العرض
    // (Display Name) بتاع حساب X كبديل مؤقت في بروفايلنا.
    if ((user.email == null || user.email!.isEmpty) &&
        user.displayName != null) {
      await createUserDocument(uid: user.uid, email: '');
      await updateUserDocument(user.uid, {
        'firstName': user.displayName,
        'lastName': '',
      });
    }

    return user;
  }
  Future<void> signOut() => firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail(String email) {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// بيتنفذ مرة واحدة بس عند إنشاء الحساب، بيعمل مستند "profile" فاضي
  /// في users/{uid} — نفس المجموعة (Collection) اللي وثقناها في قسم 10
  /// من الدليل.
  Future<void> createUserDocument({
    required String uid,
    required String email,
  }) {
    return firestore.collection('users').doc(uid).set({
      'firstName': '',
      'lastName': '',
      'email': email,
      'role': 'customer',
      'language': 'en',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    final snapshot = await firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) {
    return firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }
}