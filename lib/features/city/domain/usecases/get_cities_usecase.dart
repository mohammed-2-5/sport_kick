import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';

/// Get Cities Use Case
///
/// Fetches all active cities from the repository.
class GetCitiesUseCase {
  final CityRepository repository;

  const GetCitiesUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns a list of active cities.
  Future<Either<Failure, List<CityEntity>>> call() async {
    return await repository.getCities();
  }
}
