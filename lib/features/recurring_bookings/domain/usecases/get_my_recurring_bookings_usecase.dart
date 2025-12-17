import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for getting user's recurring bookings.
class GetMyRecurringBookingsUseCase {
  final RecurringBookingRepository _repository;

  GetMyRecurringBookingsUseCase(this._repository);

  Future<Either<Failure, List<RecurringBookingEntity>>> call() {
    return _repository.getMyRecurringBookings();
  }
}
