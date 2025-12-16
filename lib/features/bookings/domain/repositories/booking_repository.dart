import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

import '../entities/booking_status.dart';

/// Booking repository interface.
///
/// Defines the contract for booking data operations.
/// Implemented in the data layer.
abstract class BookingRepository {
  /// Get all bookings for the current user.
  Future<Either<Failure, List<BookingEntity>>> getUserBookings();

  /// Get booking by ID.
  Future<Either<Failure, BookingEntity>> getBookingById(String bookingId);

  /// Get available time slots for a field on a specific date.
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  });

  /// Create a new booking.
  Future<Either<Failure, BookingEntity>> createBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    String? notes,
    int durationHours = 1,
  });

  /// Cancel a booking.
  Future<Either<Failure, BookingEntity>> cancelBooking({
    required String bookingId,
    required String reason,
  });

  /// Update booking status (for field owners/admins).
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  });

  /// Get bookings filtered by status.
  Future<Either<Failure, List<BookingEntity>>> getBookingsByStatus({
    required BookingStatus status,
  });

  /// Get upcoming bookings (confirmed and in future).
  Future<Either<Failure, List<BookingEntity>>> getUpcomingBookings();

  /// Get booking history (completed and canceled).
  Future<Either<Failure, List<BookingEntity>>> getBookingHistory();

  /// Get all bookings for fields owned by the current user (for owner dashboard).
  Future<Either<Failure, List<BookingEntity>>> getOwnerBookings();

  /// Get all bookings in the system (for super admin only).
  Future<Either<Failure, List<BookingEntity>>> getAllBookings();

  /// Create a manual booking (for field owners/admins).
  ///
  /// Manual bookings are created by admins for walk-in customers.
  /// They are automatically confirmed and include customer information.
  Future<Either<Failure, BookingEntity>> createManualBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? notes,
  });

  /// Upload payment proof for a booking.
  ///
  /// Uploads the image to storage and updates the booking with the proof URL.
  /// Uses bytes for cross-platform support (web and mobile).
  Future<Either<Failure, BookingEntity>> uploadPaymentProof({
    required String bookingId,
    required Uint8List imageBytes,
    required String fileName,
  });

  /// Verify payment proof (for field owners).
  ///
  /// Marks the payment as verified and optionally confirms the booking.
  Future<Either<Failure, BookingEntity>> verifyPaymentProof({
    required String bookingId,
  });

  /// Reject payment proof (for field owners).
  ///
  /// Marks the payment as rejected with a reason.
  Future<Either<Failure, BookingEntity>> rejectPaymentProof({
    required String bookingId,
    required String reason,
  });

  /// Auto-complete expired bookings.
  ///
  /// Calls Supabase RPC to update all 'confirmed' bookings
  /// where the date + end_time has passed to 'completed' status.
  /// Returns the number of bookings that were updated.
  Future<Either<Failure, int>> completePassedBookings();
}
