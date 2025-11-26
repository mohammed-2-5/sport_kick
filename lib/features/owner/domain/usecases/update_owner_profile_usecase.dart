import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Use case to update owner profile information
class UpdateOwnerProfileUseCase {
  final OwnerRepository repository;

  UpdateOwnerProfileUseCase(this.repository);

  /// Execute the use case
  ///
  /// Updates owner's profile information (name, phone)
  Future<Either<Failure, void>> call({
    required String ownerId,
    String? fullName,
    String? phone,
  }) async {
    return await repository.updateOwnerProfile(
      ownerId: ownerId,
      fullName: fullName,
      phone: phone,
    );
  }
}
