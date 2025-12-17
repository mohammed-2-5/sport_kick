import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Use case for getting reserved recurring slots for a field.
class GetReservedSlotsUseCase {
  final RecurringBookingRepository _repository;

  GetReservedSlotsUseCase(this._repository);

  Future<Either<Failure, List<ReservedSlot>>> call(
    GetReservedSlotsParams params,
  ) {
    return _repository.getReservedSlots(fieldId: params.fieldId);
  }
}

class GetReservedSlotsParams extends Equatable {
  final String fieldId;

  const GetReservedSlotsParams({required this.fieldId});

  @override
  List<Object?> get props => [fieldId];
}
