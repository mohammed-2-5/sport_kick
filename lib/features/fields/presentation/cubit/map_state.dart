import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// State for the map cubit.
sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class MapInitial extends MapState {
  const MapInitial();
}

/// Loading user location.
class MapLocationLoading extends MapState {
  const MapLocationLoading();
}

/// User location loaded successfully.
class MapLocationLoaded extends MapState {
  final LatLng userLocation;

  const MapLocationLoaded({required this.userLocation});

  @override
  List<Object?> get props => [userLocation];
}

/// Location permission denied.
class MapLocationPermissionDenied extends MapState {
  final String message;

  const MapLocationPermissionDenied({
    this.message = 'Location permission denied',
  });

  @override
  List<Object?> get props => [message];
}

/// Location service disabled.
class MapLocationServiceDisabled extends MapState {
  const MapLocationServiceDisabled();
}

/// Error getting location.
class MapLocationError extends MapState {
  final String message;

  const MapLocationError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Map filters applied.
class MapFiltersApplied extends MapState {
  final MapFilters filters;

  const MapFiltersApplied({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Filter options for the map.
class MapFilters extends Equatable {
  /// Show only verified fields.
  final bool verifiedOnly;

  /// Show only fields with rating >= this value.
  final double? minRating;

  /// Maximum price per hour.
  final double? maxPrice;

  /// Filter by surface type (grass, turf, indoor).
  final String? surfaceType;

  /// Sort by distance from user location.
  final bool sortByDistance;

  const MapFilters({
    this.verifiedOnly = false,
    this.minRating,
    this.maxPrice,
    this.surfaceType,
    this.sortByDistance = false,
  });

  MapFilters copyWith({
    bool? verifiedOnly,
    double? minRating,
    double? maxPrice,
    String? surfaceType,
    bool? sortByDistance,
    bool clearMinRating = false,
    bool clearMaxPrice = false,
    bool clearSurfaceType = false,
  }) {
    return MapFilters(
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      surfaceType: clearSurfaceType ? null : (surfaceType ?? this.surfaceType),
      sortByDistance: sortByDistance ?? this.sortByDistance,
    );
  }

  bool get hasActiveFilters =>
      verifiedOnly ||
      minRating != null ||
      maxPrice != null ||
      surfaceType != null;

  /// Apply filters to a list of fields.
  List<FieldEntity> applyTo(List<FieldEntity> fields) {
    var filtered = fields;

    if (verifiedOnly) {
      filtered = filtered.where((f) => f.isVerified).toList();
    }

    if (minRating != null) {
      filtered = filtered
          .where((f) => f.hasReviews && (f.averageRating ?? 0) >= minRating!)
          .toList();
    }

    if (maxPrice != null) {
      filtered = filtered.where((f) => f.pricePerHour <= maxPrice!).toList();
    }

    if (surfaceType != null) {
      // Handle "Indoor" as a special case - it's a boolean field, not a surface type
      if (surfaceType!.toLowerCase() == 'indoor') {
        filtered = filtered.where((f) => f.isIndoor).toList();
      } else {
        // For other surface types, use flexible matching
        // (e.g., "Grass" should match "Natural Grass", "Turf" matches "Artificial Turf")
        final surfaceLower = surfaceType!.toLowerCase();
        filtered = filtered
            .where(
              (f) =>
                  f.surfaceType != null &&
                  f.surfaceType!.toLowerCase().contains(surfaceLower),
            )
            .toList();
      }
    }

    return filtered;
  }

  @override
  List<Object?> get props => [
    verifiedOnly,
    minRating,
    maxPrice,
    surfaceType,
    sortByDistance,
  ];
}
