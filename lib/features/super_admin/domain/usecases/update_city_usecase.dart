import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for updating an existing city.
///
/// Updates city properties like name or active status.
class UpdateCityUseCase {
  final SuperAdminRepository repository;

  UpdateCityUseCase({required this.repository});

  /// Update an existing city.
  ///
  /// Parameters:
  /// - [cityId]: ID of the city to update
  /// - [name]: New city name (optional)
  /// - [isActive]: New active status (optional)
  ///
  /// Returns:
  /// - [Right(CityEntity)]: City updated successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, CityEntity>> call({
    required String cityId,
    String? name,
    bool? isActive,
  }) {
    return repository.updateCity(
      cityId: cityId,
      name: name,
      isActive: isActive,
    );
  }
}
