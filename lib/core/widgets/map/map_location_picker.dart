import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/services/nominatim_geocoding_service.dart';
import 'package:spo_kick/core/widgets/map/map_location_picker_widgets.dart';

/// Full-screen map location picker using OpenStreetMap.
///
/// Features:
/// - Draggable marker for precise location selection
/// - Search bar with Nominatim geocoding
/// - Current location button
/// - Reverse geocoding on marker move
///
/// Returns [LocationData] on confirmation, or null if cancelled.
class MapLocationPicker extends StatefulWidget {
  /// Initial location to show on map.
  final LocationData? initialLocation;

  /// Title shown in app bar.
  final String title;

  const MapLocationPicker({
    super.key,
    this.initialLocation,
    this.title = 'Select Location',
  });

  /// Shows the map picker and returns selected location.
  static Future<LocationData?> show(
    BuildContext context, {
    LocationData? initialLocation,
    String title = 'Select Location',
  }) async {
    return Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) =>
            MapLocationPicker(initialLocation: initialLocation, title: title),
      ),
    );
  }

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late LatLng _markerPosition;
  LocationData? _selectedLocation;
  List<LocationData> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingAddress = false;
  bool _showSearchResults = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialLocation ?? LocationData.defaultLocation;
    _markerPosition = LatLng(initial.latitude, initial.longitude);
    _selectedLocation = widget.initialLocation;

    if (widget.initialLocation == null) {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
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
      setState(() => _markerPosition = newPosition);
      _mapController.move(newPosition, MapLocationPickerConstants.defaultZoom);
      _reverseGeocode(newPosition);
    } catch (e) {
      debugPrint('[MapPicker] Location error: $e');
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    _debounceTimer = Timer(MapLocationPickerConstants.searchDebounce, () async {
      final results = await NominatimGeocodingService.searchAddress(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
          _showSearchResults = results.isNotEmpty;
        });
      }
    });
  }

  void _onSearchResultSelected(LocationData location) {
    HapticFeedback.selectionClick();
    final newPosition = LatLng(location.latitude, location.longitude);
    setState(() {
      _markerPosition = newPosition;
      _selectedLocation = location;
      _showSearchResults = false;
      _searchResults = [];
    });
    _searchController.clear();
    _searchFocusNode.unfocus();
    _mapController.move(newPosition, MapLocationPickerConstants.defaultZoom);
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      setState(() => _markerPosition = camera.center);
    }
  }

  void _onMapMoveEnd() {
    _reverseGeocode(_markerPosition);
  }

  Future<void> _reverseGeocode(LatLng position) async {
    setState(() => _isLoadingAddress = true);

    final result = await NominatimGeocodingService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (mounted) {
      setState(() {
        _selectedLocation =
            result ??
            LocationData(
              address: 'Unknown location',
              latitude: position.latitude,
              longitude: position.longitude,
            );
        _isLoadingAddress = false;
      });
    }
  }

  void _onConfirm() {
    if (_selectedLocation != null) {
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(_selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Map
          _buildMap(),

          // Center marker
          _buildCenterMarker(),

          // Search bar and results
          _buildSearchOverlay(),

          // My location FAB
          _buildLocationFab(),

          // Bottom info sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MapLocationInfoSheet(
              location: _selectedLocation,
              isLoading: _isLoadingAddress,
              onConfirm: _onConfirm,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _markerPosition,
        initialZoom: MapLocationPickerConstants.defaultZoom,
        minZoom: MapLocationPickerConstants.minZoom,
        maxZoom: MapLocationPickerConstants.maxZoom,
        onPositionChanged: _onMapPositionChanged,
        onMapEvent: (event) {
          if (event is MapEventMoveEnd) _onMapMoveEnd();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapLocationPickerConstants.tileUrl,
          userAgentPackageName: 'com.sportkick.app',
        ),
      ],
    );
  }

  Widget _buildCenterMarker() {
    return const Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: MapLocationPickerConstants.bottomSheetHeight,
      child: Center(child: MapLocationMarker()),
    );
  }

  Widget _buildSearchOverlay() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: MapLocationPickerConstants.horizontalPadding,
      right: MapLocationPickerConstants.horizontalPadding,
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(
                MapLocationPickerConstants.searchBarRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: MapLocationPickerConstants.searchHint,
                hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.accentCyan,
                ),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Search results
          if (_showSearchResults && _searchResults.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(
                  MapLocationPickerConstants.borderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return MapSearchResultItem(
                    location: _searchResults[index],
                    onTap: () => _onSearchResultSelected(_searchResults[index]),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationFab() {
    return Positioned(
      right: MapLocationPickerConstants.horizontalPadding,
      bottom: MapLocationPickerConstants.bottomSheetHeight + 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: AppColors.surfaceWhite,
        onPressed: _getCurrentLocation,
        tooltip: MapLocationPickerConstants.myLocationTooltip,
        child: const Icon(Icons.my_location, color: AppColors.accentCyan),
      ),
    );
  }
}
