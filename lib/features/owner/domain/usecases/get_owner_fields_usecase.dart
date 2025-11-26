import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to get all fields owned by a specific owner
class GetOwnerFieldsUseCase {
  final OwnerRepository repository;

  GetOwnerFieldsUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns a list of [FieldEntity] owned by the specified owner
  Future<Either<Failure, List<FieldEntity>>> call({
    required String ownerId,
  }) async {
    return await repository.getOwnerFields(ownerId);
  }
}
