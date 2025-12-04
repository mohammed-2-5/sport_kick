import 'package:flutter/foundation.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Extension for city management operations.
///
/// Handles loading cities for field creation and management.
extension CityOperations on SuperAdminCubit {
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
}
