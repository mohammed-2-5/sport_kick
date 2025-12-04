import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';

/// Repository interface for Business Hours operations.
///
/// This interface defines the contract for business hours data operations.
/// The actual implementation is in the data layer.
abstract class BusinessHoursRepository {
  /// Gets business hours for a specific field.
  ///
  /// Returns a list of [BusinessHoursEntity] for all 7 days of the week.
  /// Returns [Failure] if the operation fails.
  Future<Either<Failure, List<BusinessHoursEntity>>> getFieldBusinessHours(
    String fieldId,
  );

  /// Updates business hours for a specific day.
  ///
  /// [fieldId] - The field to update hours for
  /// [dayOfWeek] - The day to update (0-6)
  /// [isOpen] - Whether the field is open on this day
  /// [openingTime] - Opening time (HH:mm:ss format)
  /// [closingTime] - Closing time (HH:mm:ss format)
  ///
  /// Returns the updated [BusinessHoursEntity] or [Failure].
  Future<Either<Failure, BusinessHoursEntity>> updateBusinessHours({
    required String fieldId,
    required int dayOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  });

  /// Updates business hours for multiple days at once.
  ///
  /// [fieldId] - The field to update hours for
  /// [updates] - Map of day (0-6) to BusinessHoursEntity updates
  ///
  /// Returns list of updated [BusinessHoursEntity] or [Failure].
  Future<Either<Failure, List<BusinessHoursEntity>>>
  updateMultipleBusinessHours({
    required String fieldId,
    required Map<int, BusinessHoursEntity> updates,
  });

  /// Initializes default business hours (24/7) for a field.
  ///
  /// Creates business hours records for all 7 days with 24/7 operation.
  /// Typically called when a new field is created.
  ///
  /// Returns [void] on success or [Failure] on error.
  Future<Either<Failure, void>> initializeDefaultBusinessHours(String fieldId);

  /// Validates if a booking time is within business hours.
  ///
  /// [fieldId] - The field to check
  /// [bookingTime] - The proposed booking time
  ///
  /// Returns [bool] indicating if the time is valid, or [Failure].
  Future<Either<Failure, bool>> validateBookingTime({
    required String fieldId,
    required DateTime bookingTime,
  });

  /// Checks if a field is currently open.
  ///
  /// [fieldId] - The field to check
  ///
  /// Returns [bool] indicating if the field is currently open, or [Failure].
  Future<Either<Failure, bool>> isFieldCurrentlyOpen(String fieldId);

  /// Gets the next opening time for a field.
  ///
  /// [fieldId] - The field to check
  /// [fromTime] - Starting time to search from (defaults to now)
  ///
  /// Returns [DateTime] of next opening or null if closed for 7+ days.
  /// Returns [Failure] if operation fails.
  Future<Either<Failure, DateTime?>> getNextOpeningTime({
    required String fieldId,
    DateTime? fromTime,
  });
}
