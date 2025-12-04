import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/domain/usecases/clear_selected_city_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_cities_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_city_by_id_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_selected_city_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/save_selected_city_usecase.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';

/// City Cubit
///
/// Manages city selection state and operations.
class CityCubit extends Cubit<CityState> {
  final GetCitiesUseCase getCities;
  final SaveSelectedCityUseCase saveSelectedCity;
  final GetSelectedCityUseCase getSelectedCity;
  final ClearSelectedCityUseCase clearSelectedCity;
  final GetCityByIdUseCase getCityById;

  CityCubit({
    required this.getCities,
    required this.saveSelectedCity,
    required this.getSelectedCity,
    required this.clearSelectedCity,
    required this.getCityById,
  }) : super(const CityInitial());

  /// Load all available cities
  Future<void> loadCities() async {
    emit(const CitiesLoading());

    final result = await getCities();

    result.fold(
      (failure) {
        debugPrint('[CityCubit] Failed to load cities: ${failure.message}');
        emit(CityError(failure.message));
      },
      (cities) async {
        // Also check if there's a previously selected city
        final selectedResult = await getSelectedCity();
        selectedResult.fold(
          (_) => emit(CitiesLoaded(cities: cities)),
          (selectedCityId) => emit(
            CitiesLoaded(cities: cities, selectedCityId: selectedCityId),
          ),
        );
      },
    );
  }

  /// Select a city
  void selectCity(CityEntity city) {
    emit(CitySelected(city));
  }

  /// Save selected city
  Future<void> saveCity(CityEntity city) async {
    emit(CitySaving(city));

    final result = await saveSelectedCity(city.id);

    result.fold(
      (failure) {
        debugPrint('[CityCubit] Failed to save city: ${failure.message}');
        emit(CityError(failure.message));
      },
      (_) {
        debugPrint('[CityCubit] City saved: ${city.name}');
        emit(CitySaved(city: city, message: CityConstants.citySelectedSuccess));
        // Immediately transition to CitySelected to maintain state
        emit(CitySelected(city));
      },
    );
  }

  /// Get currently selected city
  Future<void> loadSelectedCity() async {
    // Don't emit loading if we already have a selected city
    if (state is CitySelected) return;

    emit(const CitiesLoading());
    debugPrint('🔍 [CITY CUBIT] Loading selected city ID from cache...');

    final result = await getSelectedCity();

    await result.fold(
      (failure) async {
        debugPrint('❌ [CITY CUBIT] Failed to get city ID: ${failure.message}');
        // If we fail to get the ID, we should just load all cities so the user can pick one
        await loadCities();
      },
      (cityId) async {
        if (cityId == null || cityId.isEmpty) {
          debugPrint('⚠️ [CITY CUBIT] No city ID found in cache');
          // No city selected, load all cities for selection
          await loadCities();
          return;
        }

        debugPrint(
          '✅ [CITY CUBIT] Found city ID: $cityId. Fetching details...',
        );

        // Fetch the full city details
        final cityResult = await getCityById(cityId);
        await cityResult.fold(
          (failure) async {
            debugPrint(
              '❌ [CITY CUBIT] Failed to fetch city details: ${failure.message}',
            );
            // If we have an ID but can't fetch details (e.g. network error),
            // we should probably still try to load cities or show error
            await loadCities();
          },
          (city) async {
            debugPrint('✅ [CITY CUBIT] Successfully loaded city: ${city.name}');
            emit(CitySelected(city));
          },
        );
      },
    );
  }

  /// Clear selected city
  Future<void> clearCity() async {
    final result = await clearSelectedCity();

    result.fold(
      (failure) {
        debugPrint('[CityCubit] Failed to clear city: ${failure.message}');
        emit(CityError(failure.message));
      },
      (_) {
        debugPrint('[CityCubit] City selection cleared');
        loadCities();
      },
    );
  }
}
