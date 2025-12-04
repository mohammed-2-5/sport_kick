import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';

/// Save Selected City Use Case
///
/// Saves the user's selected city to local storage.
class SaveSelectedCityUseCase {
  final CityRepository repository;

  const SaveSelectedCityUseCase(this.repository);

  /// Execute the use case
  ///
  /// [cityId] - ID of the city to save
  Future<Either<Failure, void>> call(String cityId) async {
    return await repository.saveSelectedCity(cityId);
  }
}
