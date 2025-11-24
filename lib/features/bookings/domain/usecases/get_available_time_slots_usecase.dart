import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for getting available time slots for a field.
class GetAvailableTimeSlotsUseCase {
  final BookingRepository repository;

  GetAvailableTimeSlotsUseCase(this.repository);

  Future<Either<Failure, List<TimeSlotEntity>>> call({
    required String fieldId,
    required DateTime date,
  }) async {
    // Validate date is not in the past
    final today = DateTime.now();
    final bookingDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (bookingDate.isBefore(todayDate)) {
      return Left(ValidationFailure('Cannot view slots for past dates'));
    }

    return await repository.getAvailableTimeSlots(
      fieldId: fieldId,
      date: date,
    );
  }
}
