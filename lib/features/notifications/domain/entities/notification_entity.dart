import 'package:equatable/equatable.dart';

/// Notification types in the system.
enum NotificationType { booking, payment, system, review }

/// Extension on NotificationType for string conversion.
extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.booking:
        return 'booking';
      case NotificationType.payment:
        return 'payment';
      case NotificationType.system:
        return 'system';
      case NotificationType.review:
        return 'review';
    }
  }

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'booking':
        return NotificationType.booking;
      case 'payment':
        return NotificationType.payment;
      case 'system':
        return NotificationType.system;
      case 'review':
        return NotificationType.review;
      default:
        return NotificationType.system;
    }
  }
}

/// Entity representing a notification in the domain layer.
///
/// This is immutable and contains only business logic relevant data.
/// Updated: December 2025
class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String? referenceId;
  final String? referenceType;
  final bool isRead;
  final bool isSent;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? readAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    this.referenceType,
    this.isRead = false,
    this.isSent = false,
    this.data = const {},
    required this.createdAt,
    this.readAt,
  });

  /// Create a copy with modified fields.
  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    String? referenceId,
    String? referenceType,
    bool? isRead,
    bool? isSent,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      isRead: isRead ?? this.isRead,
      isSent: isSent ?? this.isSent,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  /// Check if notification is for a booking.
  bool get isBookingNotification => type == NotificationType.booking;

  /// Check if notification is for a payment.
  bool get isPaymentNotification => type == NotificationType.payment;

  /// Get booking ID from data if available.
  String? get bookingId => data['booking_id'] as String?;

  /// Get field ID from data if available.
  String? get fieldId => data['field_id'] as String?;

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    body,
    type,
    referenceId,
    referenceType,
    isRead,
    isSent,
    data,
    createdAt,
    readAt,
  ];
}
