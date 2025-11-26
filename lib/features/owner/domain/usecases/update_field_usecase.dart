import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to update field details
class UpdateFieldUseCase {
  final OwnerRepository repository;

  UpdateFieldUseCase(this.repository);

  /// Execute the use case
  ///
  /// Updates a field with the provided [updates] map
  /// Returns the updated [FieldEntity]
  Future<Either<Failure, FieldEntity>> call({
    required String fieldId,
    required Map<String, dynamic> updates,
  }) async {
    return await repository.updateField(fieldId, updates);
  }
}
