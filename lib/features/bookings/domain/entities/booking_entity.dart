import 'package:equatable/equatable.dart';

import 'booking_status.dart';
import 'payment_status.dart';

/// Booking entity representing a field booking.
///
/// Contains all information about a field booking including
/// user, field, time slot, status, pricing, and payment details.
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

  // Duration fields
  final int durationHours; // 1 or 2 hours

  // Payment fields
  final PaymentStatus paymentStatus;
  final String? paymentProofUrl; // URL to payment screenshot
  final DateTime? paymentUploadedAt;
  final String? invoiceNumber; // Format: INV-YYYYMMDD-XXXX
  final DateTime? paymentVerifiedAt;
  final String? paymentRejectionReason;

  // Manual booking fields (for admin-created bookings)
  final bool isManual;
  final String? createdBy; // Admin user ID who created the manual booking
  final String? createdByName; // Admin name who created the manual booking
  final String? createdByEmail; // Admin email who created the manual booking
  final String? customerName; // For walk-in customers
  final String? customerPhone; // For walk-in customers
  final String? customerEmail; // For walk-in customers (optional)

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
    this.durationHours = 1,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentProofUrl,
    this.paymentUploadedAt,
    this.invoiceNumber,
    this.paymentVerifiedAt,
    this.paymentRejectionReason,
    this.isManual = false,
    this.createdBy,
    this.createdByName,
    this.createdByEmail,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
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
    durationHours,
    paymentStatus,
    paymentProofUrl,
    paymentUploadedAt,
    invoiceNumber,
    paymentVerifiedAt,
    paymentRejectionReason,
    isManual,
    createdBy,
    createdByName,
    createdByEmail,
    customerName,
    customerPhone,
    customerEmail,
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
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Get formatted time slot (e.g., "09:00 - 10:00")
  String get formattedTimeSlot => '$startTime - $endTime';

  /// Get formatted price (e.g., "200 EGP")
  String get formattedPrice => '${totalPrice.toStringAsFixed(0)} $currency';

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
  bool get isUpcoming => status == BookingStatus.confirmed && !isPast;

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

  /// Check if payment proof is uploaded
  bool get hasPaymentProof =>
      paymentProofUrl != null && paymentProofUrl!.isNotEmpty;

  /// Check if payment needs user action
  bool get paymentNeedsUserAction => paymentStatus.needsUserAction;

  /// Check if payment needs owner action
  bool get paymentNeedsOwnerAction => paymentStatus.needsOwnerAction;

  /// Check if payment is complete
  bool get isPaymentComplete => paymentStatus.isComplete;

  /// Get payment status display text
  String get paymentStatusText => paymentStatus.displayName;

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
    int? durationHours,
    PaymentStatus? paymentStatus,
    String? paymentProofUrl,
    DateTime? paymentUploadedAt,
    String? invoiceNumber,
    DateTime? paymentVerifiedAt,
    String? paymentRejectionReason,
    bool? isManual,
    String? createdBy,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
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
      durationHours: durationHours ?? this.durationHours,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
      paymentUploadedAt: paymentUploadedAt ?? this.paymentUploadedAt,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      paymentVerifiedAt: paymentVerifiedAt ?? this.paymentVerifiedAt,
      paymentRejectionReason:
          paymentRejectionReason ?? this.paymentRejectionReason,
      isManual: isManual ?? this.isManual,
      createdBy: createdBy ?? this.createdBy,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
    );
  }
}
