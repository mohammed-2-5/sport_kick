import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';

/// Use case for checking if a field is currently open.
///
/// Determines if the field is open at the current moment based on
/// current day of week and time.
class IsFieldCurrentlyOpenUseCase {
  final BusinessHoursRepository repository;

  const IsFieldCurrentlyOpenUseCase(this.repository);

  /// Executes the use case.
  ///
  /// [fieldId] - The ID of the field to check
  ///
  /// Returns [bool]:
  /// - true: Field is currently open
  /// - false: Field is currently closed
  ///
  /// Returns [Failure] if the operation fails.
  Future<Either<Failure, bool>> call(String fieldId) async {
    if (fieldId.isEmpty) {
      return Left(ValidationFailure('Field ID cannot be empty'));
    }

    return await repository.isFieldCurrentlyOpen(fieldId);
  }
}
