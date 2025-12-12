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
    int durationHours = 1,
  }) async {
    // Validate date is not in the past (must be at least tomorrow)
    final today = DateTime.now();
    final bookingDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (bookingDate.isBefore(todayDate) ||
        bookingDate.isAtSameMomentAs(todayDate)) {
      return const Left(
        ValidationFailure('Bookings must be at least 1 day in advance'),
      );
    }

    // Validate time format
    if (!_isValidTimeFormat(startTime) || !_isValidTimeFormat(endTime)) {
      return const Left(ValidationFailure('Invalid time format'));
    }

    // Validate duration
    if (durationHours != 1 && durationHours != 2) {
      return const Left(ValidationFailure('Duration must be 1 or 2 hours'));
    }

    // Validate time consistency with duration
    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);

    // Handle cross-midnight: endTime could be smaller than startTime (e.g., 23:00 - 01:00)
    final expectedEndHour = (startHour + durationHours) % 24;
    if (endHour != expectedEndHour) {
      return const Left(ValidationFailure('End time does not match duration'));
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
      durationHours: durationHours,
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
