import 'package:spo_kick/features/notifications/domain/entities/notification_entity.dart';

/// Data model for notifications from Supabase.
///
/// Handles JSON serialization/deserialization for the notifications table.
/// Updated: December 2025
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    super.referenceId,
    super.referenceType,
    super.isRead = false,
    super.isSent = false,
    super.data = const {},
    required super.createdAt,
    super.readAt,
  });

  /// Create from Supabase JSON response.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationTypeExtension.fromString(
        json['type'] as String? ?? 'system',
      ),
      referenceId: json['reference_id'] as String?,
      referenceType: json['reference_type'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      isSent: json['is_sent'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for Supabase operations.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type.value,
      'reference_id': referenceId,
      'reference_type': referenceType,
      'is_read': isRead,
      'is_sent': isSent,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  /// Convert entity to model.
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      referenceId: entity.referenceId,
      referenceType: entity.referenceType,
      isRead: entity.isRead,
      isSent: entity.isSent,
      data: entity.data,
      createdAt: entity.createdAt,
      readAt: entity.readAt,
    );
  }
}
