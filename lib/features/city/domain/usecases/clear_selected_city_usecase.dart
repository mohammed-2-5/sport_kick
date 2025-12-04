import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';

/// Clear Selected City Use Case
///
/// Removes the selected city from local storage.
class ClearSelectedCityUseCase {
  final CityRepository repository;

  const ClearSelectedCityUseCase(this.repository);

  /// Execute the use case
  ///
  /// Clears the user's city selection.
  Future<Either<Failure, void>> call() async {
    return await repository.clearSelectedCity();
  }
}
