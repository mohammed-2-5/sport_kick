import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for creating a recurring booking request.
class CreateRecurringRequestUseCase {
  final RecurringBookingRepository _repository;

  CreateRecurringRequestUseCase(this._repository);

  Future<Either<Failure, String>> call(CreateRecurringRequestParams params) {
    return _repository.createRecurringRequest(
      fieldId: params.fieldId,
      dayOfWeek: params.dayOfWeek,
      startTime: params.startTime,
      durationHours: params.durationHours,
    );
  }
}

class CreateRecurringRequestParams extends Equatable {
  final String fieldId;
  final int dayOfWeek;
  final String startTime;
  final int durationHours;

  const CreateRecurringRequestParams({
    required this.fieldId,
    required this.dayOfWeek,
    required this.startTime,
    this.durationHours = 1,
  });

  @override
  List<Object?> get props => [fieldId, dayOfWeek, startTime, durationHours];
}
