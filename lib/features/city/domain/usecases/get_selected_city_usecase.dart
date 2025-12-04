import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/repositories/city_repository.dart';

/// Get Selected City Use Case
///
/// Retrieves the user's previously selected city ID from local storage.
class GetSelectedCityUseCase {
  final CityRepository repository;

  const GetSelectedCityUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns the selected city ID, or null if none selected.
  Future<Either<Failure, String?>> call() async {
    return await repository.getSelectedCityId();
  }
}
