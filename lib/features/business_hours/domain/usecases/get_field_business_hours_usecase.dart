import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

/// Use case for retrieving business hours for a specific field.
///
/// Returns business hours for all 7 days of the week.
class GetFieldBusinessHoursUseCase {
  final BusinessHoursRepository repository;

  const GetFieldBusinessHoursUseCase(this.repository);

  /// Executes the use case.
  ///
  /// [fieldId] - The ID of the field to get business hours for
  ///
  /// Returns a list of [BusinessHoursEntity] ordered by day of week (0-6).
  /// Returns [Failure] if the operation fails.
  Future<Either<Failure, List<BusinessHoursEntity>>> call(
    String fieldId,
  ) async {
    return await repository.getFieldBusinessHours(fieldId);
  }
}
