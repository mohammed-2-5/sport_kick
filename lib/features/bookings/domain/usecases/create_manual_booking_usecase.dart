import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';

/// Use case for creating a manual booking (admin-created booking for walk-in customers).
///
/// Manual bookings are created by field owners/admins and are:
/// - Automatically confirmed (no approval needed)
/// - Created for walk-in customers (customer info provided by admin)
/// - Linked to the admin who created it
///
/// Validates input and delegates to repository.
class CreateManualBookingUseCase {
  final BookingRepository repository;

  CreateManualBookingUseCase(this.repository);

  Future<Either<Failure, BookingEntity>> call({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
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
      return const Left(ValidationFailure('Total price must be greater than zero'));
    }

    // Validate customer name
    if (customerName.trim().isEmpty) {
      return const Left(ValidationFailure('Customer name is required'));
    }

    if (customerName.trim().length < 2) {
      return const Left(
        ValidationFailure('Customer name must be at least 2 characters'),
      );
    }

    // Validate customer phone
    if (customerPhone.trim().isEmpty) {
      return const Left(ValidationFailure('Customer phone number is required'));
    }

    // Basic phone validation (Egyptian numbers: 11 digits starting with 01)
    final phoneRegex = RegExp(r'^01[0-2,5]\d{8}$');
    final cleanPhone = customerPhone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!phoneRegex.hasMatch(cleanPhone)) {
      return const Left(
        ValidationFailure(
          'Invalid phone number. Egyptian numbers should be 11 digits starting with 01',
        ),
      );
    }

    // Validate email if provided
    if (customerEmail != null && customerEmail.trim().isNotEmpty) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(customerEmail.trim())) {
        return const Left(ValidationFailure('Invalid email format'));
      }
    }

    return await repository.createManualBooking(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      customerName: customerName.trim(),
      customerPhone: cleanPhone,
      customerEmail:
          customerEmail != null && customerEmail.trim().isNotEmpty
              ? customerEmail.trim()
              : null,
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
