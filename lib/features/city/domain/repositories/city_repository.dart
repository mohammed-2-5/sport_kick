import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// City Repository Interface
///
/// Defines contract for city data operations.
abstract class CityRepository {
  /// Get all active cities
  ///
  /// Returns a list of active cities from the backend.
  Future<Either<Failure, List<CityEntity>>> getCities();

  /// Save selected city
  ///
  /// Saves the user's selected city to local storage.
  /// [cityId] - ID of the selected city
  Future<Either<Failure, void>> saveSelectedCity(String cityId);

  /// Get selected city ID
  ///
  /// Retrieves the user's previously selected city ID from local storage.
  /// Returns null if no city has been selected.
  Future<Either<Failure, String?>> getSelectedCityId();

  /// Clear selected city
  ///
  /// Removes the selected city from local storage.
  Future<Either<Failure, void>> clearSelectedCity();

  /// Get city by ID
  ///
  /// Retrieves a specific city by its ID.
  /// [cityId] - ID of the city to retrieve
  Future<Either<Failure, CityEntity>> getCityById(String cityId);
}
