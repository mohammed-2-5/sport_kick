import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for canceling a booking.
class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call({
    required String bookingId,
    required String reason,
  }) async {
    // Validate reason is not empty
    if (reason.trim().isEmpty) {
      return Left(ValidationFailure('Cancellation reason is required'));
    }

    return await repository.cancelBooking(
      bookingId: bookingId,
      reason: reason,
    );
  }
}
