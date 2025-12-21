import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';
import 'package:spo_kick/features/fields/presentation/utils/location_service.dart';

/// Cubit for managing map-related state.
///
/// Handles:
/// - User location
/// - Map filters
/// - Distance calculations
class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapInitial());

  /// Current user location (if available).
  LatLng? _userLocation;

  /// Current map filters.
  MapFilters _filters = const MapFilters();

  /// Get current user location.
  LatLng? get userLocation => _userLocation;

  /// Get current filters.
  MapFilters get filters => _filters;

  /// Get and center on user's current location.
  ///
  /// Requests permission if needed.
  /// Returns the user's location or null if unavailable.
  Future<LatLng?> getUserLocation() async {
    emit(const MapLocationLoading());

    try {
      // Check if location services are enabled
      final isAvailable = await LocationService.isLocationAvailable();

      if (!isAvailable) {
        // Try to request permission
        final granted = await LocationService.requestPermission();

        if (!granted) {
          emit(
            const MapLocationPermissionDenied(
              message: 'Please enable location permissions in settings.',
            ),
          );
          return null;
        }
      }

      // Get current location with an overall timeout
      final location = await LocationService.getCurrentLocation().timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );

      if (location == null) {
        emit(
          const MapLocationError(message: 'Could not determine your location.'),
        );
        return null;
      }

      _userLocation = location;
      emit(MapLocationLoaded(userLocation: location));
      return location;
    } catch (e) {
      // Ensure we exit loading state on any error
      emit(MapLocationError(message: 'Location error: ${e.toString()}'));
      return null;
    }
  }

  /// Update map filters.
  void updateFilters(MapFilters newFilters) {
    _filters = newFilters;
    emit(MapFiltersApplied(filters: newFilters));
  }

  /// Set verified only filter.
  void setVerifiedOnly(bool value) {
    _filters = _filters.copyWith(verifiedOnly: value);
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Set minimum rating filter.
  void setMinRating(double? value) {
    if (value == null) {
      _filters = _filters.copyWith(clearMinRating: true);
    } else {
      _filters = _filters.copyWith(minRating: value);
    }
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Set maximum price filter.
  void setMaxPrice(double? value) {
    if (value == null) {
      _filters = _filters.copyWith(clearMaxPrice: true);
    } else {
      _filters = _filters.copyWith(maxPrice: value);
    }
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Set surface type filter.
  void setSurfaceType(String? value) {
    if (value == null) {
      _filters = _filters.copyWith(clearSurfaceType: true);
    } else {
      _filters = _filters.copyWith(surfaceType: value);
    }
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Toggle sort by distance.
  void setSortByDistance(bool value) {
    _filters = _filters.copyWith(sortByDistance: value);
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Clear all filters.
  void clearFilters() {
    _filters = const MapFilters();
    emit(MapFiltersApplied(filters: _filters));
  }

  /// Reset to initial state.
  void reset() {
    _userLocation = null;
    _filters = const MapFilters();
    emit(const MapInitial());
  }
}
