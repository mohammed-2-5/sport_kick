import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';

/// Get City By ID Use Case
///
/// Retrieves a specific city by its ID.
class GetCityByIdUseCase {
  final CityRepository repository;

  const GetCityByIdUseCase(this.repository);

  /// Execute the use case
  ///
  /// [cityId] - ID of the city to retrieve
  /// Returns the city entity.
  Future<Either<Failure, CityEntity>> call(String cityId) async {
    return await repository.getCityById(cityId);
  }
}
