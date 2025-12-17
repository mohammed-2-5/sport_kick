import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for rejecting a recurring booking request (owner action).
class RejectRecurringBookingUseCase {
  final RecurringBookingRepository _repository;

  RejectRecurringBookingUseCase(this._repository);

  Future<Either<Failure, bool>> call(RejectRecurringBookingParams params) {
    return _repository.rejectRecurringBooking(
      recurringBookingId: params.recurringBookingId,
      reason: params.reason,
    );
  }
}

class RejectRecurringBookingParams extends Equatable {
  final String recurringBookingId;
  final String reason;

  const RejectRecurringBookingParams({
    required this.recurringBookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [recurringBookingId, reason];
}
