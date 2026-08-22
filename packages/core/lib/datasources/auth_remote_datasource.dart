import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

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
