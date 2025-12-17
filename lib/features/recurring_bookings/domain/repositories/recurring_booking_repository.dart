import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';

/// Repository interface for recurring booking operations.
abstract class RecurringBookingRepository {
  // ============================================================================
  // USER OPERATIONS
  // ============================================================================

  /// Create a new recurring booking request.
  ///
  /// Returns the ID of the created recurring booking.
  Future<Either<Failure, String>> createRecurringRequest({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
    required int durationHours,
  });

  /// Cancel an active recurring booking.
  ///
  /// Requires 1 week notice - bookings within the next week will remain.
  Future<Either<Failure, bool>> cancelRecurringBooking({
    required String recurringBookingId,
    String? reason,
  });

  /// Get all recurring bookings for the current user.
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getMyRecurringBookings();

  // ============================================================================
  // OWNER OPERATIONS
  // ============================================================================

  /// Approve a pending recurring booking request.
  ///
  /// This will generate 4 weeks of pending bookings.
  Future<Either<Failure, bool>> approveRecurringBooking({
    required String recurringBookingId,
  });

  /// Reject a pending recurring booking request.
  Future<Either<Failure, bool>> rejectRecurringBooking({
    required String recurringBookingId,
    required String reason,
  });

  /// Get all pending recurring requests for owner's fields.
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getPendingRecurringRequests();

  /// Get all active recurring bookings for owner's fields.
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getActiveRecurringBookingsForOwner();

  // ============================================================================
  // UTILITY OPERATIONS
  // ============================================================================

  /// Check if a specific slot is reserved by a recurring booking.
  Future<Either<Failure, bool>> isSlotReserved({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
  });

  /// Get all reserved recurring slots for a field.
  Future<Either<Failure, List<ReservedSlot>>> getReservedSlots({
    required String fieldId,
  });
}

/// Represents a reserved recurring slot for UI display.
class ReservedSlot {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? userName;

  const ReservedSlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.userName,
  });
}
