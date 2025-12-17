import 'package:equatable/equatable.dart';

/// Status of a recurring booking subscription.
enum RecurringBookingStatus {
  pendingApproval,
  active,
  canceled,
  rejected;

  static RecurringBookingStatus fromString(String value) {
    switch (value) {
      case 'pending_approval':
        return RecurringBookingStatus.pendingApproval;
      case 'active':
        return RecurringBookingStatus.active;
      case 'canceled':
        return RecurringBookingStatus.canceled;
      case 'rejected':
        return RecurringBookingStatus.rejected;
      default:
        return RecurringBookingStatus.pendingApproval;
    }
  }

  String toDbString() {
    switch (this) {
      case RecurringBookingStatus.pendingApproval:
        return 'pending_approval';
      case RecurringBookingStatus.active:
        return 'active';
      case RecurringBookingStatus.canceled:
        return 'canceled';
      case RecurringBookingStatus.rejected:
        return 'rejected';
    }
  }

  String get displayName {
    switch (this) {
      case RecurringBookingStatus.pendingApproval:
        return 'Pending Approval';
      case RecurringBookingStatus.active:
        return 'Active';
      case RecurringBookingStatus.canceled:
        return 'Canceled';
      case RecurringBookingStatus.rejected:
        return 'Rejected';
    }
  }
}

/// Entity representing a recurring booking subscription.
///
/// A recurring booking reserves a specific weekly time slot
/// and auto-generates individual bookings up to 4 weeks ahead.
class RecurringBookingEntity extends Equatable {
  final String id;
  final String fieldId;
  final String fieldName;
  final String? fieldImageUrl;
  final String? cityName;
  final int dayOfWeek; // 0=Saturday, 1=Sunday, ..., 6=Friday
  final String startTime;
  final String endTime;
  final int durationHours;
  final double pricePerBooking;
  final RecurringBookingStatus status;
  final String? rejectionReason;
  final DateTime? startedAt;
  final DateTime createdAt;
  final DateTime? nextBookingDate;
  final bool? nextBookingPaid;
  final int totalBookingsCount;
  final int completedBookingsCount;

  // For pending requests (owner view)
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? userAvatarUrl;

  const RecurringBookingEntity({
    required this.id,
    required this.fieldId,
    required this.fieldName,
    this.fieldImageUrl,
    this.cityName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.pricePerBooking,
    required this.status,
    this.rejectionReason,
    this.startedAt,
    required this.createdAt,
    this.nextBookingDate,
    this.nextBookingPaid,
    this.totalBookingsCount = 0,
    this.completedBookingsCount = 0,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userAvatarUrl,
  });

  /// Get the day name from day of week index.
  String get dayName {
    const days = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    return days[dayOfWeek];
  }

  /// Get short day name.
  String get shortDayName {
    const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return days[dayOfWeek];
  }

  /// Format time range for display.
  String get timeRange => '$startTime - $endTime';

  /// Check if this is an active subscription.
  bool get isActive => status == RecurringBookingStatus.active;

  /// Check if this is pending approval.
  bool get isPending => status == RecurringBookingStatus.pendingApproval;

  /// Get remaining bookings count.
  int get remainingBookingsCount => totalBookingsCount - completedBookingsCount;

  /// Check if next booking needs payment.
  bool get needsPayment =>
      isActive && nextBookingDate != null && nextBookingPaid == false;

  @override
  List<Object?> get props => [
    id,
    fieldId,
    fieldName,
    fieldImageUrl,
    cityName,
    dayOfWeek,
    startTime,
    endTime,
    durationHours,
    pricePerBooking,
    status,
    rejectionReason,
    startedAt,
    createdAt,
    nextBookingDate,
    nextBookingPaid,
    totalBookingsCount,
    completedBookingsCount,
    userId,
    userName,
    userEmail,
    userPhone,
    userAvatarUrl,
  ];
}
