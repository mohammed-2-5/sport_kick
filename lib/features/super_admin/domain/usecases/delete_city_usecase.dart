import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for deleting a city.
///
/// Supports both soft deletion (deactivation) and hard deletion.
class DeleteCityUseCase {
  final SuperAdminRepository repository;

  DeleteCityUseCase({required this.repository});

  /// Delete a city.
  ///
  /// Parameters:
  /// - [cityId]: ID of the city to delete
  /// - [hardDelete]: If true, permanently deletes; if false, deactivates
  ///
  /// Returns:
  /// - [Right(void)]: City deleted successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> call({
    required String cityId,
    required bool hardDelete,
  }) {
    return repository.deleteCity(cityId: cityId, hardDelete: hardDelete);
  }
}
