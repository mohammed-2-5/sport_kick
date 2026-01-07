import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_city_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_city_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_state.dart';

/// Cubit for city management operations.
///
/// Handles:
/// - Loading cities list
/// - Creating new cities
/// - Updating existing cities
/// - Deleting cities (soft/hard)
class CityManagementCubit extends Cubit<CityManagementState> {
  final GetActiveCitiesUseCase getActiveCitiesUseCase;
  final CreateCityUseCase createCityUseCase;
  final UpdateCityUseCase updateCityUseCase;
  final DeleteCityUseCase deleteCityUseCase;

  CityManagementCubit({
    required this.getActiveCitiesUseCase,
    required this.createCityUseCase,
    required this.updateCityUseCase,
    required this.deleteCityUseCase,
  }) : super(const CityManagementInitial());

  /// Load list of active cities.
  Future<void> loadCities() async {
    debugPrint('🔄 [CityManagementCubit] Loading cities...');
    emit(const CityManagementLoading(message: 'Loading cities...'));

    final result = await getActiveCitiesUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CityManagementCubit] Error loading cities: ${failure.message}',
        );
        emit(CityManagementError(failure.message));
      },
      (cities) {
        debugPrint('✅ [CityManagementCubit] Loaded ${cities.length} cities');
        emit(CitiesLoaded(cities));
      },
    );
  }

  /// Create a new city.
  Future<void> createCity({required String name, bool isActive = true}) async {
    debugPrint('🏙️ [CityManagementCubit] Creating city: $name');
    emit(const CityManagementLoading(message: 'Creating city...'));

    final result = await createCityUseCase(name: name, isActive: isActive);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CityManagementCubit] Error creating city: ${failure.message}',
        );
        emit(CityManagementError(failure.message));
      },
      (city) {
        debugPrint('✅ [CityManagementCubit] City created: ${city.name}');
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
    debugPrint('🏙️ [CityManagementCubit] Updating city: $cityId');
    emit(const CityManagementLoading(message: 'Updating city...'));

    final result = await updateCityUseCase(
      cityId: cityId,
      name: name,
      isActive: isActive,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CityManagementCubit] Error updating city: ${failure.message}',
        );
        emit(CityManagementError(failure.message));
      },
      (city) {
        debugPrint('✅ [CityManagementCubit] City updated: ${city.name}');
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
    debugPrint('🏙️ [CityManagementCubit] City $action: $cityId');
    emit(const CityManagementLoading(message: 'Deleting city...'));

    final result = await deleteCityUseCase(
      cityId: cityId,
      hardDelete: hardDelete,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CityManagementCubit] Error deleting city: ${failure.message}',
        );
        emit(CityManagementError(failure.message));
      },
      (_) {
        debugPrint('✅ [CityManagementCubit] City deleted successfully');
        emit(CityDeleted(cityId: cityId, wasHardDelete: hardDelete));
        loadCities(); // Refresh list
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    emit(const CityManagementInitial());
  }
}
