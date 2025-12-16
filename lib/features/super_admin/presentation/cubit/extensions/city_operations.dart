import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_city_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for city management operations.
///
/// Handles:
/// - Loading cities list
/// - Creating new cities
/// - Updating existing cities
/// - Deleting cities (soft/hard)
mixin CityOperations on Cubit<SuperAdminState> {
  // Dependencies
  GetActiveCitiesUseCase get getActiveCitiesUseCase;
  CreateCityUseCase get createCityUseCase;
  UpdateCityUseCase get updateCityUseCase;
  DeleteCityUseCase get deleteCityUseCase;

  /// Load list of active cities.
  Future<void> loadCities() async {
    debugPrint('🔄 [SuperAdminCubit] Loading cities...');
    emit(const SuperAdminLoading(message: 'Loading cities...'));

    final result = await getActiveCitiesUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading cities: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (cities) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${cities.length} cities');
        emit(CitiesLoaded(cities));
      },
    );
  }

  /// Create a new city.
  Future<void> createCity({required String name, bool isActive = true}) async {
    debugPrint('🏙️ [SuperAdminCubit] Creating city: $name');
    emit(const SuperAdminLoading(message: 'Creating city...'));

    final result = await createCityUseCase(name: name, isActive: isActive);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error creating city: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (city) {
        debugPrint('✅ [SuperAdminCubit] City created: ${city.name}');
        emit(CityCreated(city));
        loadCities(); // Refresh list
      },
    );
  }

  /// Update an existing city.
  Future<void> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  }) async {
    debugPrint('🏙️ [SuperAdminCubit] Updating city: $cityId');
    emit(const SuperAdminLoading(message: 'Updating city...'));

    final result = await updateCityUseCase(
      cityId: cityId,
      name: name,
      isActive: isActive,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error updating city: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (city) {
        debugPrint('✅ [SuperAdminCubit] City updated: ${city.name}');
        emit(CityUpdated(city));
        loadCities(); // Refresh list
      },
    );
  }

  /// Delete a city (soft or hard delete).
  Future<void> deleteCity({
    required String cityId,
    required bool hardDelete,
  }) async {
    final action = hardDelete ? 'permanently deleting' : 'deactivating';
    debugPrint('🏙️ [SuperAdminCubit] City $action: $cityId');
    emit(const SuperAdminLoading(message: 'Deleting city...'));

    final result = await deleteCityUseCase(
      cityId: cityId,
      hardDelete: hardDelete,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error deleting city: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        debugPrint('✅ [SuperAdminCubit] City deleted successfully');
        emit(CityDeleted(cityId: cityId, wasHardDelete: hardDelete));
        loadCities(); // Refresh list
      },
    );
  }
}
