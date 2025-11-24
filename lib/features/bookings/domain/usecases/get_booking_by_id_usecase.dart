import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for getting a single booking by ID.
class GetBookingByIdUseCase {
  final BookingRepository repository;

  GetBookingByIdUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call(String bookingId) async {
    if (bookingId.trim().isEmpty) {
      return Left(ValidationFailure('Booking ID is required'));
    }

    return await repository.getBookingById(bookingId);
  }
}
