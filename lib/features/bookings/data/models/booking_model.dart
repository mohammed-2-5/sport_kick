import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

import '../../domain/entities/booking_status.dart';
import '../../domain/entities/payment_status.dart';

/// Booking data model (DTO) for JSON serialization.
///
/// Maps between database JSON and domain entity.
/// Optimized for Supabase PostgreSQL schema.
class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.fieldId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.totalPrice,
    required super.currency,
    super.userName,
    super.fieldName,
    super.fieldImage,
    required super.createdAt,
    super.confirmedAt,
    super.canceledAt,
    super.cancellationReason,
    super.notes,
    super.durationHours,
    super.paymentStatus,
    super.paymentProofUrl,
    super.paymentUploadedAt,
    super.invoiceNumber,
    super.paymentVerifiedAt,
    super.paymentRejectionReason,
    super.isManual,
    super.createdBy,
    super.createdByName,
    super.createdByEmail,
    super.customerName,
    super.customerPhone,
    super.customerEmail,
  });

  /// Create model from JSON (from Supabase).
  ///
  /// Handles both simple bookings and enriched data with joins.
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fieldId: json['field_id'] as String,
      date: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: (json['status'] as String).toBookingStatus(),
      totalPrice: (json['total_price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      // Optional fields from joins
      userName: json['user_name'] as String?,
      fieldName: json['field_name'] as String?,
      fieldImage: json['field_image'] as String?,
      // Timestamps
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      canceledAt: json['canceled_at'] != null
          ? DateTime.parse(json['canceled_at'] as String)
          : null,
      cancellationReason: json['cancellation_reason'] as String?,
      notes: json['notes'] as String?,
      // Duration and payment fields
      durationHours: json['duration_hours'] as int? ?? 1,
      paymentStatus: PaymentStatus.fromString(
        json['payment_status'] as String?,
      ),
      paymentProofUrl: json['payment_proof_url'] as String?,
      paymentUploadedAt: json['payment_uploaded_at'] != null
          ? DateTime.parse(json['payment_uploaded_at'] as String)
          : null,
      invoiceNumber: json['invoice_number'] as String?,
      paymentVerifiedAt: json['payment_verified_at'] != null
          ? DateTime.parse(json['payment_verified_at'] as String)
          : null,
      paymentRejectionReason: json['payment_rejection_reason'] as String?,
      // Manual booking fields
      isManual: json['is_manual'] as bool? ?? false,
      createdBy: json['created_by'] as String?,
      // Parse creator profile from nested join if available
      createdByName: _parseCreatorName(json),
      createdByEmail: _parseCreatorEmail(json),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      customerEmail: json['customer_email'] as String?,
    );
  }

  /// Parse creator name from nested profile join or direct fields
  static String? _parseCreatorName(Map<String, dynamic> json) {
    // Check nested creator_profile (from join)
    if (json['creator_profile'] is Map) {
      final profile = json['creator_profile'] as Map<String, dynamic>;
      return profile['full_name'] as String?;
    }
    // Fallback to direct field
    return json['created_by_name'] as String?;
  }

  /// Parse creator email from nested profile join or direct fields
  static String? _parseCreatorEmail(Map<String, dynamic> json) {
    // Check nested creator_profile (from join)
    if (json['creator_profile'] is Map) {
      final profile = json['creator_profile'] as Map<String, dynamic>;
      return profile['email'] as String?;
    }
    // Fallback to direct field
    return json['created_by_email'] as String?;
  }

  /// Convert model to JSON (for Supabase).
  ///
  /// Only includes fields needed for insert/update operations.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'field_id': fieldId,
      'booking_date': date.toIso8601String().split('T')[0], // Date only
      'start_time': startTime,
      'end_time': endTime,
      'status': status.toShortString(),
      'total_price': totalPrice,
      'currency': currency,
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'created_at': createdAt.toIso8601String(),
      if (confirmedAt != null) 'confirmed_at': confirmedAt!.toIso8601String(),
      if (canceledAt != null) 'canceled_at': canceledAt!.toIso8601String(),
      // Duration and payment fields
      'duration_hours': durationHours,
      'payment_status': paymentStatus.name,
      if (paymentProofUrl != null) 'payment_proof_url': paymentProofUrl,
      if (paymentUploadedAt != null)
        'payment_uploaded_at': paymentUploadedAt!.toIso8601String(),
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (paymentVerifiedAt != null)
        'payment_verified_at': paymentVerifiedAt!.toIso8601String(),
      if (paymentRejectionReason != null)
        'payment_rejection_reason': paymentRejectionReason,
      // Manual booking fields
      'is_manual': isManual,
      if (createdBy != null) 'created_by': createdBy,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerEmail != null) 'customer_email': customerEmail,
    };
  }

  /// Create model for insert (without id and timestamps).
  ///
  /// Used when creating a new booking.
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'field_id': fieldId,
      'booking_date': date.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'total_price': totalPrice,
      'currency': currency,
      'duration_hours': durationHours,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      // Manual booking fields
      'is_manual': isManual,
      if (isManual)
        'status': 'confirmed', // Manual bookings are confirmed immediately
      if (createdBy != null) 'created_by': createdBy,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerEmail != null && customerEmail!.isNotEmpty)
        'customer_email': customerEmail,
      // Don't include id, created_at (auto-generated by database)
      // Invoice number is auto-generated by database trigger
      // Payment status defaults to 'pending'
    };
  }

  /// Create model for payment proof update.
  ///
  /// Used when user uploads payment screenshot.
  Map<String, dynamic> toPaymentProofUpdateJson() {
    return {
      'payment_proof_url': paymentProofUrl,
      'payment_status': 'uploaded',
      'payment_uploaded_at': DateTime.now().toIso8601String(),
    };
  }

  /// Create model for payment verification update.
  ///
  /// Used when owner verifies or rejects payment.
  Map<String, dynamic> toPaymentVerificationJson({
    required bool verified,
    String? rejectionReason,
  }) {
    if (verified) {
      return {
        'payment_status': 'verified',
        'payment_verified_at': DateTime.now().toIso8601String(),
      };
    } else {
      return {
        'payment_status': 'rejected',
        'payment_rejection_reason': rejectionReason,
      };
    }
  }

  /// Create model for status update.
  ///
  /// Optimized for updating only status-related fields.
  Map<String, dynamic> toStatusUpdateJson() {
    return {
      'status': status.toShortString(),
      if (status == BookingStatus.canceled && cancellationReason != null)
        'cancellation_reason': cancellationReason,
    };
  }

  /// Convert from entity to model.
  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      fieldId: entity.fieldId,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      totalPrice: entity.totalPrice,
      currency: entity.currency,
      userName: entity.userName,
      fieldName: entity.fieldName,
      fieldImage: entity.fieldImage,
      createdAt: entity.createdAt,
      confirmedAt: entity.confirmedAt,
      canceledAt: entity.canceledAt,
      cancellationReason: entity.cancellationReason,
      notes: entity.notes,
      durationHours: entity.durationHours,
      paymentStatus: entity.paymentStatus,
      paymentProofUrl: entity.paymentProofUrl,
      paymentUploadedAt: entity.paymentUploadedAt,
      invoiceNumber: entity.invoiceNumber,
      paymentVerifiedAt: entity.paymentVerifiedAt,
      paymentRejectionReason: entity.paymentRejectionReason,
      isManual: entity.isManual,
      createdBy: entity.createdBy,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      customerEmail: entity.customerEmail,
    );
  }

  /// Convert model to entity.
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      userId: userId,
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: status,
      totalPrice: totalPrice,
      currency: currency,
      userName: userName,
      fieldName: fieldName,
      fieldImage: fieldImage,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      canceledAt: canceledAt,
      cancellationReason: cancellationReason,
      notes: notes,
      durationHours: durationHours,
      paymentStatus: paymentStatus,
      paymentProofUrl: paymentProofUrl,
      paymentUploadedAt: paymentUploadedAt,
      invoiceNumber: invoiceNumber,
      paymentVerifiedAt: paymentVerifiedAt,
      paymentRejectionReason: paymentRejectionReason,
      isManual: isManual,
      createdBy: createdBy,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
    );
  }

  /// Create a copy with updated fields.
  @override
  BookingModel copyWith({
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
    return BookingModel(
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
