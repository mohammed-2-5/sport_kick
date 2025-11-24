import 'package:equatable/equatable.dart';

import 'booking_status.dart';

/// Booking entity representing a field booking.
///
/// Contains all information about a field booking including
/// user, field, time slot, status, and pricing.
class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String fieldId;
  final DateTime date;
  final String startTime; // Format: "09:00"
  final String endTime; // Format: "10:00"
  final BookingStatus status;
  final double totalPrice;
  final String currency;
  final String? userName;
  final String? fieldName;
  final String? fieldImage;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? canceledAt;
  final String? cancellationReason;
  final String? notes;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    required this.currency,
    this.userName,
    this.fieldName,
    this.fieldImage,
    required this.createdAt,
    this.confirmedAt,
    this.canceledAt,
    this.cancellationReason,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fieldId,
        date,
        startTime,
        endTime,
        status,
        totalPrice,
        currency,
        userName,
        fieldName,
        fieldImage,
        createdAt,
        confirmedAt,
        canceledAt,
        cancellationReason,
        notes,
      ];

  /// Get formatted date string (e.g., "Jan 15, 2025")
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Get formatted time slot (e.g., "09:00 - 10:00")
  String get formattedTimeSlot => '$startTime - $endTime';

  /// Get formatted price (e.g., "200 EGP")
  String get formattedPrice =>
      '${totalPrice.toStringAsFixed(0)} $currency';

  /// Check if booking is in the past
  bool get isPast {
    final bookingDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(endTime.split(':')[0]),
      int.parse(endTime.split(':')[1]),
    );
    return bookingDateTime.isBefore(DateTime.now());
  }

  /// Check if booking is upcoming (confirmed and in future)
  bool get isUpcoming =>
      status == BookingStatus.confirmed && !isPast;

  /// Check if booking can be canceled
  bool get canCancel =>
      status == BookingStatus.pending ||
      (status == BookingStatus.confirmed && !isPast);

  /// Get status color
  String get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return 'warning';
      case BookingStatus.confirmed:
        return 'success';
      case BookingStatus.canceled:
        return 'error';
      case BookingStatus.completed:
        return 'info';
    }
  }

  /// Get status display text
  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.canceled:
        return 'Canceled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  /// Get duration in hours
  int get durationInHours {
    final start = int.parse(startTime.split(':')[0]);
    final end = int.parse(endTime.split(':')[0]);
    return end - start;
  }

  /// Create a copy with updated fields
  BookingEntity copyWith({
    String? id,
    String? userId,
    String? fieldId,
    DateTime? date,
    String? startTime,
    String? endTime,
    BookingStatus? status,
    double? totalPrice,
    String? currency,
    String? userName,
    String? fieldName,
    String? fieldImage,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? canceledAt,
    String? cancellationReason,
    String? notes,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fieldId: fieldId ?? this.fieldId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      userName: userName ?? this.userName,
      fieldName: fieldName ?? this.fieldName,
      fieldImage: fieldImage ?? this.fieldImage,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      notes: notes ?? this.notes,
    );
  }
}

