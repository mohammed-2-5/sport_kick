import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

class DeleteFieldUseCase {
  final OwnerRepository repository;

  DeleteFieldUseCase(this.repository);

  Future<Either<Failure, void>> call(String fieldId) async {
    return await repository.deleteField(fieldId);
  }
}
