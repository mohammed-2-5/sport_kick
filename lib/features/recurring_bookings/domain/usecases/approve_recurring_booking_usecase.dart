import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for approving a recurring booking request (owner action).
class ApproveRecurringBookingUseCase {
  final RecurringBookingRepository _repository;

  ApproveRecurringBookingUseCase(this._repository);

  Future<Either<Failure, bool>> call(ApproveRecurringBookingParams params) {
    return _repository.approveRecurringBooking(
      recurringBookingId: params.recurringBookingId,
    );
  }
}

class ApproveRecurringBookingParams extends Equatable {
  final String recurringBookingId;

  const ApproveRecurringBookingParams({required this.recurringBookingId});

  @override
  List<Object?> get props => [recurringBookingId];
}
