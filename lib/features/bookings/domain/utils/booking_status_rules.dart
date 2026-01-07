import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Business rules for booking status transitions.
///
/// Encapsulates domain logic for how booking statuses should change
/// based on business rules and booking type.
class BookingStatusRules {
  /// Determine the initial status for a new booking.
  ///
  /// Business Rule: Manual bookings created by admins/owners are
  /// automatically confirmed. Regular user bookings start as pending.
  ///
  /// Parameters:
  /// - [isManual] - Whether booking is created manually by admin/owner
  ///
  /// Returns the appropriate initial [BookingStatus].
  static BookingStatus getInitialStatus({required bool isManual}) {
    return isManual ? BookingStatus.confirmed : BookingStatus.pending;
  }

  /// Determine the initial status string for database insert.
  ///
  /// Returns string representation for database operations.
  static String getInitialStatusString({required bool isManual}) {
    final status = getInitialStatus(isManual: isManual);
    return status.toShortString();
  }

  /// Check if a booking can be canceled based on its current status.
  ///
  /// Business Rule: Only pending or confirmed bookings can be canceled.
  static bool canBeCanceled(BookingStatus currentStatus) {
    return currentStatus == BookingStatus.pending ||
        currentStatus == BookingStatus.confirmed;
  }

  /// Check if a booking can be confirmed based on its current status.
  ///
  /// Business Rule: Only pending bookings can be confirmed.
  static bool canBeConfirmed(BookingStatus currentStatus) {
    return currentStatus == BookingStatus.pending;
  }

  /// Check if a booking can be completed based on its current status.
  ///
  /// Business Rule: Only confirmed bookings can be marked as completed.
  static bool canBeCompleted(BookingStatus currentStatus) {
    return currentStatus == BookingStatus.confirmed;
  }

  /// Get allowed status transitions from current status.
  ///
  /// Returns list of statuses that can be transitioned to.
  static List<BookingStatus> getAllowedTransitions(
    BookingStatus currentStatus,
  ) {
    switch (currentStatus) {
      case BookingStatus.pending:
        return [BookingStatus.confirmed, BookingStatus.canceled];
      case BookingStatus.confirmed:
        return [BookingStatus.completed, BookingStatus.canceled];
      case BookingStatus.canceled:
      case BookingStatus.completed:
        return []; // Terminal states - no transitions allowed
    }
  }

  /// Validate if a status transition is allowed.
  ///
  /// Throws [StateError] if transition is not allowed.
  static void validateTransition({
    required BookingStatus from,
    required BookingStatus to,
  }) {
    final allowedTransitions = getAllowedTransitions(from);

    if (!allowedTransitions.contains(to)) {
      throw StateError(
        'Cannot transition from ${from.displayName} to ${to.displayName}',
      );
    }
  }
}
