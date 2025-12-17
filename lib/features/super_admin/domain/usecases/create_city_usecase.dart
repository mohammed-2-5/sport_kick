import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for creating a new city.
///
/// Creates a new city in the platform database.
class CreateCityUseCase {
  final SuperAdminRepository repository;

  CreateCityUseCase({required this.repository});

  /// Create a new city.
  ///
  /// Parameters:
  /// - [name]: City name
  /// - [isActive]: Whether city is active (default: true)
  ///
  /// Returns:
  /// - [Right(CityEntity)]: City created successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, CityEntity>> call({
    required String name,
    bool isActive = true,
  }) {
    return repository.createCity(name: name, isActive: isActive);
  }
}
