import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

import '../entities/booking_status.dart';

/// Use case for updating booking status.
///
/// This is used by field owners to approve or reject booking requests.
class UpdateBookingStatusUseCase {
  final BookingRepository repository;

  UpdateBookingStatusUseCase(this.repository);

  /// Update the status of a booking.
  ///
  /// [bookingId] - The ID of the booking to update
  /// [status] - The new status (confirmed, canceled, etc.)
  Future<Either<Failure, BookingEntity>> call({
    required String bookingId,
    required BookingStatus status,
  }) async {
    return await repository.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );
  }
}
