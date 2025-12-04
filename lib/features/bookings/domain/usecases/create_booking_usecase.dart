import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for creating a new booking.
///
/// Validates input and delegates to repository.
class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    String? notes,
  }) async {
    // Validate date is not in the past
    final today = DateTime.now();
    final bookingDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (bookingDate.isBefore(todayDate)) {
      return const Left(ValidationFailure('Cannot book a date in the past'));
    }

    // Validate time format
    if (!_isValidTimeFormat(startTime) || !_isValidTimeFormat(endTime)) {
      return const Left(ValidationFailure('Invalid time format'));
    }

    // Validate start time is before end time
    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);

    if (startHour >= endHour) {
      return const Left(ValidationFailure('End time must be after start time'));
    }

    // Validate totalPrice is positive
    if (totalPrice <= 0) {
      return const Left(
        ValidationFailure('Total price must be greater than zero'),
      );
    }

    return await repository.createBooking(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      notes: notes,
    );
  }

  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^\d{2}:\d{2}$');
    if (!regex.hasMatch(time)) return false;

    final parts = time.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    return hour != null &&
        minute != null &&
        hour >= 0 &&
        hour < 24 &&
        minute >= 0 &&
        minute < 60;
  }
}
