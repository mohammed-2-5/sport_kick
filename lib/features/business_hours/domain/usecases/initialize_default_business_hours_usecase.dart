import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

/// Use case for initializing default business hours for a field.
///
/// Creates business hours records for all 7 days with 24/7 operation.
/// Typically called when a new field is created or when an owner wants
/// to reset hours to default.
class InitializeDefaultBusinessHoursUseCase {
  final BusinessHoursRepository repository;

  const InitializeDefaultBusinessHoursUseCase(this.repository);

  /// Executes the use case.
  ///
  /// [fieldId] - The ID of the field to initialize hours for
  ///
  /// Returns [void] on success or [Failure] if the operation fails.
  Future<Either<Failure, void>> call(String fieldId) async {
    if (fieldId.isEmpty) {
      return const Left(ValidationFailure('Field ID cannot be empty'));
    }

    return await repository.initializeDefaultBusinessHours(fieldId);
  }
}
