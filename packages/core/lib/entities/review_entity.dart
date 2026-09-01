import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewEntity.fromJson(String id, Map<String, dynamic> json) {
    return ReviewEntity(
      id: id,
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userPhotoUrl: json['userPhotoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        if (userPhotoUrl != null) 'userPhotoUrl': userPhotoUrl,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props =>
      [id, userId, userName, userPhotoUrl, rating, comment, createdAt];
}
