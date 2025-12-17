import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';

/// Data model for recurring booking with JSON serialization.
class RecurringBookingModel extends RecurringBookingEntity {
  const RecurringBookingModel({
    required super.id,
    required super.fieldId,
    required super.fieldName,
    super.fieldImageUrl,
    super.cityName,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.durationHours,
    required super.pricePerBooking,
    required super.status,
    super.rejectionReason,
    super.startedAt,
    required super.createdAt,
    super.nextBookingDate,
    super.nextBookingPaid,
    super.totalBookingsCount,
    super.completedBookingsCount,
    super.userId,
    super.userName,
    super.userEmail,
    super.userPhone,
    super.userAvatarUrl,
  });

  /// Create model from user's recurring bookings query result.
  factory RecurringBookingModel.fromUserJson(Map<String, dynamic> json) {
    return RecurringBookingModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      fieldName: json['field_name'] as String? ?? '',
      fieldImageUrl: json['field_image_url'] as String?,
      cityName: json['city_name'] as String?,
      dayOfWeek: json['day_of_week'] as int,
      startTime: _formatTime(json['start_time']),
      endTime: _formatTime(json['end_time']),
      durationHours: json['duration_hours'] as int? ?? 1,
      pricePerBooking: (json['price_per_booking'] as num?)?.toDouble() ?? 0.0,
      status: RecurringBookingStatus.fromString(json['status'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      nextBookingDate: json['next_booking_date'] != null
          ? DateTime.parse(json['next_booking_date'] as String)
          : null,
      nextBookingPaid: json['next_booking_paid'] as bool?,
      totalBookingsCount: (json['total_bookings_count'] as num?)?.toInt() ?? 0,
      completedBookingsCount:
          (json['completed_bookings_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Create model from pending requests query result (owner view).
  factory RecurringBookingModel.fromPendingRequestJson(
    Map<String, dynamic> json,
  ) {
    return RecurringBookingModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      fieldName: json['field_name'] as String? ?? '',
      dayOfWeek: json['day_of_week'] as int,
      startTime: _formatTime(json['start_time']),
      endTime: _formatTime(json['end_time']),
      durationHours: json['duration_hours'] as int? ?? 1,
      pricePerBooking: (json['price_per_booking'] as num?)?.toDouble() ?? 0.0,
      status: RecurringBookingStatus.pendingApproval,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      userPhone: json['user_phone'] as String?,
      userAvatarUrl: json['user_avatar_url'] as String?,
    );
  }

  /// Create model from active recurring bookings query result (owner view).
  factory RecurringBookingModel.fromActiveOwnerJson(Map<String, dynamic> json) {
    return RecurringBookingModel(
      id: json['id'] as String,
      fieldId: json['field_id'] as String,
      fieldName: json['field_name'] as String? ?? '',
      dayOfWeek: json['day_of_week'] as int,
      startTime: _formatTime(json['start_time']),
      endTime: _formatTime(json['end_time']),
      durationHours: json['duration_hours'] as int? ?? 1,
      pricePerBooking: (json['price_per_booking'] as num?)?.toDouble() ?? 0.0,
      status: RecurringBookingStatus.active,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      createdAt: DateTime.now(),
      completedBookingsCount: (json['total_completed'] as num?)?.toInt() ?? 0,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
    );
  }

  /// Format time from database format (HH:mm:ss) to display format (HH:mm).
  static String _formatTime(dynamic time) {
    if (time == null) return '00:00';
    final timeStr = time.toString();
    // Handle both HH:mm:ss and HH:mm formats
    final parts = timeStr.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return timeStr;
  }

  /// Convert to entity.
  RecurringBookingEntity toEntity() => this;
}
