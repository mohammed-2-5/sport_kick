import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

/// Parameters for validating booking time.
class ValidateBookingTimeParams {
  final String fieldId;
  final DateTime bookingTime;

  const ValidateBookingTimeParams({
    required this.fieldId,
    required this.bookingTime,
  });
}

/// Use case for validating if a booking time is within business hours.
///
/// Checks if a proposed booking time falls within the field's operating hours
/// for that specific day and time.
class ValidateBookingTimeUseCase {
  final BusinessHoursRepository repository;

  const ValidateBookingTimeUseCase(this.repository);

  /// Executes the use case.
  ///
  /// [params] - Parameters containing field ID and proposed booking time
  ///
  /// Returns [bool] indicating if the time is valid:
  /// - true: Booking time is within business hours
  /// - false: Booking time is outside business hours
  ///
  /// Returns [Failure] if the operation fails.
  Future<Either<Failure, bool>> call(ValidateBookingTimeParams params) async {
    if (params.fieldId.isEmpty) {
      return const Left(ValidationFailure('Field ID cannot be empty'));
    }

    // Don't allow bookings in the past
    if (params.bookingTime.isBefore(DateTime.now())) {
      return const Right(false);
    }

    return await repository.validateBookingTime(
      fieldId: params.fieldId,
      bookingTime: params.bookingTime,
    );
  }
}
