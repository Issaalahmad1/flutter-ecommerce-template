import 'package:equatable/equatable.dart';

enum UserRole { customer, admin }

class UserEntity extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? dob;
  final String? gender;
  final String? photoUrl;
  final UserRole role;
  final String language;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dob,
    this.gender,
    this.photoUrl,
    this.role = UserRole.customer,
    this.language = 'en',
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get isAdmin => role == UserRole.admin;

  factory UserEntity.fromJson(String uid, Map<String, dynamic> json) {
    return UserEntity(
      uid: uid,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob'] as String) : null,
      gender: json['gender'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      language: json['language'] as String? ?? 'en',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'photoUrl': photoUrl,
      'role': role.name,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [uid, firstName, lastName, email, phone, dob, gender, photoUrl, role, language, createdAt];
}
