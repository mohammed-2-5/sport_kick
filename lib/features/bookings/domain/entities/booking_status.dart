import 'package:flutter/material.dart';

/// Booking status enum
enum BookingStatus { pending, confirmed, canceled, completed }

/// Extension to convert string to BookingStatus
extension BookingStatusExtension on String {
  BookingStatus toBookingStatus() {
    switch (toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'canceled':
        return BookingStatus.canceled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}

/// Extension to convert BookingStatus to string + UI helpers
extension BookingStatusStringExtension on BookingStatus {
  /// Raw string value (e.g. 'pending')
  String toShortString() {
    return toString().split('.').last;
  }

  /// User-friendly display name
  String get displayName {
    switch (this) {
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

  /// Chip color (optional)
  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return const Color(0xFFFFA726); // Orange
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50); // Green
      case BookingStatus.canceled:
        return const Color(0xFFE53935); // Red
      case BookingStatus.completed:
        return const Color(0xFF42A5F5); // Blue
    }
  }

  /// Gradient for status badge
  LinearGradient get gradient {
    switch (this) {
      case BookingStatus.pending:
        return const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
        );
      case BookingStatus.confirmed:
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        );
      case BookingStatus.canceled:
        return const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFEF5350)],
        );
      case BookingStatus.completed:
        return const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
        );
    }
  }

  /// Icon for status
  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.pending_actions_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.canceled:
        return Icons.cancel_rounded;
      case BookingStatus.completed:
        return Icons.done_all_rounded;
    }
  }
}
