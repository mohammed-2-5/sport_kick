import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';

/// Use case for getting field details by ID.
///
/// Returns detailed information about a specific field.
///
/// Usage:
/// ```dart
/// final result = await getFieldByIdUseCase('field-123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (field) => print('Field: ${field.name}'),
/// );
/// ```
class GetFieldByIdUseCase {
  final FieldRepository repository;

  const GetFieldByIdUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [fieldId] - Unique identifier of the field
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (network, server, not found)
  /// - [FieldEntity] on success
  Future<Either<Failure, FieldEntity>> call(String fieldId) async {
    if (fieldId.isEmpty) {
      return const Left(ValidationFailure('Field ID cannot be empty'));
    }

    return await repository.getFieldById(fieldId);
  }
}
