import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for getting all bookings in the system.
///
/// This is for super admin only to view all bookings across all fields.
///
/// Example:
/// ```dart
/// final useCase = GetAllBookingsUseCase(bookingRepository);
/// final result = await useCase();
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (bookings) => print('Total bookings: ${bookings.length}'),
/// );
/// ```
class GetAllBookingsUseCase {
  final BookingRepository bookingRepository;

  GetAllBookingsUseCase(this.bookingRepository);

  /// Execute the use case.
  ///
  /// Returns:
  /// - [Right(List<BookingEntity>)]: List of all bookings
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<BookingEntity>>> call() async {
    return await bookingRepository.getAllBookings();
  }
}
