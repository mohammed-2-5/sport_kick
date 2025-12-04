import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

/// Parameters for updating business hours.
class UpdateBusinessHoursParams {
  final String fieldId;
  final int dayOfWeek;
  final bool isOpen;
  final String? openingTime;
  final String? closingTime;

  const UpdateBusinessHoursParams({
    required this.fieldId,
    required this.dayOfWeek,
    required this.isOpen,
    this.openingTime,
    this.closingTime,
  });
}

/// Use case for updating business hours for a specific day.
///
/// Validates input and updates business hours for a single day of the week.
class UpdateBusinessHoursUseCase {
  final BusinessHoursRepository repository;

  const UpdateBusinessHoursUseCase(this.repository);

  /// Executes the use case.
  ///
  /// [params] - Parameters containing field ID, day, and hour details
  ///
  /// Returns the updated [BusinessHoursEntity] or [Failure].
  Future<Either<Failure, BusinessHoursEntity>> call(
    UpdateBusinessHoursParams params,
  ) async {
    // Validate day of week
    if (params.dayOfWeek < 0 || params.dayOfWeek > 6) {
      return const Left(ValidationFailure('Invalid day of week'));
    }

    // Validate times if open
    if (params.isOpen) {
      if (params.openingTime == null || params.closingTime == null) {
        return const Left(
          ValidationFailure('Opening and closing times required when open'),
        );
      }

      // Validate time format and range
      if (!_isValidTimeFormat(params.openingTime!) ||
          !_isValidTimeFormat(params.closingTime!)) {
        return const Left(ValidationFailure('Invalid time format'));
      }

      if (!_isValidTimeRange(params.openingTime!, params.closingTime!)) {
        return const Left(
          ValidationFailure('Opening time must be before closing time'),
        );
      }
    }

    return await repository.updateBusinessHours(
      fieldId: params.fieldId,
      dayOfWeek: params.dayOfWeek,
      isOpen: params.isOpen,
      openingTime: params.openingTime,
      closingTime: params.closingTime,
    );
  }

  /// Validates time format (HH:mm:ss)
  bool _isValidTimeFormat(String time) {
    final pattern = RegExp(r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$');
    return pattern.hasMatch(time);
  }

  /// Validates that opening time is before closing time
  bool _isValidTimeRange(String openingTime, String closingTime) {
    final opening = TimeOfDay.fromString(openingTime);
    final closing = TimeOfDay.fromString(closingTime);

    if (opening == null || closing == null) return false;

    return opening.hour < closing.hour ||
        (opening.hour == closing.hour && opening.minute < closing.minute);
  }
}

/// Helper class for time parsing
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  static TimeOfDay? fromString(String time) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}
