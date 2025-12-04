import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

/// Repository interface for owner (admin) operations
///
/// Provides methods for field owners to manage their fields and bookings
abstract class OwnerRepository {
  /// Get all fields owned by a specific owner
  Future<Either<Failure, List<FieldEntity>>> getOwnerFields(String ownerId);

  /// Update field details
  Future<Either<Failure, FieldEntity>> updateField(
    String fieldId,
    Map<String, dynamic> updates,
  );

  /// Get all bookings for owner's fields
  Future<Either<Failure, List<BookingEntity>>> getOwnerBookings({
    required String ownerId,
    String? status,
  });

  /// Approve a pending booking
  Future<Either<Failure, void>> approveBooking(String bookingId);

  /// Reject a booking with a reason
  Future<Either<Failure, void>> rejectBooking(String bookingId, String reason);

  /// Get revenue statistics for owner
  Future<Either<Failure, OwnerRevenueEntity>> getOwnerRevenue(String ownerId);

  /// Update owner profile information
  Future<Either<Failure, void>> updateOwnerProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  });

  /// Delete a field
  Future<Either<Failure, void>> deleteField(String fieldId);
}
