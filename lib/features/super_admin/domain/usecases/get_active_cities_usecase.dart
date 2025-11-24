import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for getting list of active cities.
///
/// Retrieves all cities where is_active = true.
/// Used for city selection dropdown in user registration and field filtering.
///
/// Usage:
/// ```dart
/// final useCase = GetActiveCitiesUseCase(repository);
/// final result = await useCase();
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (cities) => displayCitiesDropdown(cities),
/// );
/// ```
class GetActiveCitiesUseCase {
  final SuperAdminRepository repository;

  GetActiveCitiesUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns:
  /// - [Right(List<CityEntity>)]: List of active cities
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<CityEntity>>> call() async {
    return await repository.getActiveCities();
  }
}
