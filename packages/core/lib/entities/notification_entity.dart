import 'package:equatable/equatable.dart';

/// كل نوع بيوصف حدث مختلف، والـ UI بيبني النص المعروض (بلغة التطبيق
/// الحالية) من [data] وقت العرض — مش نص جاهز مخزّن، عشان يفضل يترجم
/// صح حتى لو المستخدم غيّر لغة التطبيق بعد ما الإشعار اتسجّل.
enum NotificationType { newOrder, orderStatusChanged }

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;

  /// بيانات الحدث الخام (orderId, status, customerName, total, ...) —
  /// كل نوع بيستخدم مفاتيح مختلفة، راجع نقاط الإنشاء في
  /// NotificationRepositoryImpl.
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(String id, Map<String, dynamic> json) {
    return NotificationEntity(
      id: id,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.newOrder,
      ),
      data: Map<String, dynamic>.from(json['data'] as Map? ?? const {}),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'data': data,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, type, data, isRead, createdAt];
}
