import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/services/nominatim_geocoding_service.dart';

/// Controller managing the state and logic of map location picker.
///
/// Handles:
/// - Location search with debouncing
/// - Marker position and reverse geocoding
/// - Current location detection
/// - Map navigation
class MapLocationPickerController {
  final MapController mapController;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function() onStateChanged;

  // State variables
  LatLng markerPosition;
  LocationData? selectedLocation;
  List<LocationData> searchResults = [];
  bool isSearching = false;
  bool isLoadingAddress = false;
  bool showSearchResults = false;

  Timer? _debounceTimer;

  MapLocationPickerController({
    required this.mapController,
    required this.searchController,
    required this.searchFocusNode,
    required LocationData? initialLocation,
    required this.onStateChanged,
  }) : markerPosition = LatLng(
         initialLocation?.latitude ?? LocationData.defaultLocation.latitude,
         initialLocation?.longitude ?? LocationData.defaultLocation.longitude,
       ) {
    selectedLocation = initialLocation;
  }

  /// Gets the current location using device permissions.
  ///
  /// Updates marker position and performs reverse geocoding.
  Future<void> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final newPosition = LatLng(position.latitude, position.longitude);
      markerPosition = newPosition;
      mapController.move(newPosition, MapLocationPickerConstants.defaultZoom);
      await reverseGeocode(newPosition);
    } catch (e) {
      debugPrint('[MapPicker] Location error: $e');
    }
  }

  /// Searches for addresses matching the query with debouncing.
  ///
  /// Updates search results and loading state.
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      searchResults = [];
      showSearchResults = false;
      onStateChanged();
      return;
    }

    isSearching = true;
    onStateChanged();

    _debounceTimer = Timer(MapLocationPickerConstants.searchDebounce, () async {
      final results = await NominatimGeocodingService.searchAddress(query);
      searchResults = results;
      isSearching = false;
      showSearchResults = results.isNotEmpty;
      onStateChanged();
    });
  }

  /// Handles selection of a location from search results.
  ///
  /// Updates marker position, selected location, and navigates map.
  void onSearchResultSelected(LocationData location) {
    HapticFeedback.selectionClick();
    final newPosition = LatLng(location.latitude, location.longitude);

    markerPosition = newPosition;
    selectedLocation = location;
    showSearchResults = false;
    searchResults = [];
    onStateChanged();

    searchController.clear();
    searchFocusNode.unfocus();
    mapController.move(newPosition, MapLocationPickerConstants.defaultZoom);
  }

  /// Updates marker position when map is dragged.
  void onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      markerPosition = camera.center;
      onStateChanged();
    }
  }

  /// Handles the end of map movement.
  ///
  /// Triggers reverse geocoding for the current marker position.
  void onMapMoveEnd() {
    reverseGeocode(markerPosition);
  }

  /// Reverse geocodes coordinates to get address.
  ///
  /// Updates selected location with the address result.
  Future<void> reverseGeocode(LatLng position) async {
    isLoadingAddress = true;
    onStateChanged();

    final result = await NominatimGeocodingService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    selectedLocation =
        result ??
        LocationData(
          address: 'Unknown location',
          latitude: position.latitude,
          longitude: position.longitude,
        );

    isLoadingAddress = false;
    onStateChanged();
  }

  /// Confirms the selected location and returns it.
  ///
  /// Provides haptic feedback on confirmation.
  void confirm(VoidCallback onConfirmCallback) {
    if (selectedLocation != null) {
      HapticFeedback.mediumImpact();
      onConfirmCallback();
    }
  }

  /// Cleans up resources.
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    mapController.dispose();
  }
}
