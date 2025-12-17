import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for canceling a recurring booking subscription.
class CancelRecurringBookingUseCase {
  final RecurringBookingRepository _repository;

  CancelRecurringBookingUseCase(this._repository);

  Future<Either<Failure, bool>> call(CancelRecurringBookingParams params) {
    return _repository.cancelRecurringBooking(
      recurringBookingId: params.recurringBookingId,
      reason: params.reason,
    );
  }
}

class CancelRecurringBookingParams extends Equatable {
  final String recurringBookingId;
  final String? reason;

  const CancelRecurringBookingParams({
    required this.recurringBookingId,
    this.reason,
  });

  @override
  List<Object?> get props => [recurringBookingId, reason];
}
