import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/widgets/map/map_app_bar.dart';
import 'package:spo_kick/core/widgets/map/map_controls.dart';
import 'package:spo_kick/core/widgets/map/map_location_info_sheet.dart';
import 'package:spo_kick/core/widgets/map/map_location_picker_controller.dart';
import 'package:spo_kick/core/widgets/map/map_search_overlay.dart';
import 'package:spo_kick/core/widgets/map/map_view.dart';

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
  late MapLocationPickerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = MapLocationPickerController(
      mapController: MapController(),
      searchController: TextEditingController(),
      searchFocusNode: FocusNode(),
      initialLocation: widget.initialLocation,
      onStateChanged: () => setState(() {}),
    );

    if (widget.initialLocation == null) {
      _controller.getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          MapView(
            mapController: _controller.mapController,
            initialPosition: _controller.markerPosition,
            onPositionChanged: _controller.onMapPositionChanged,
            onMapMoveEnd: _controller.onMapMoveEnd,
          ),
          MapControls(onGetCurrentLocation: _controller.getCurrentLocation),
          MapSearchOverlay(
            searchController: _controller.searchController,
            searchFocusNode: _controller.searchFocusNode,
            searchResults: _controller.searchResults,
            isSearching: _controller.isSearching,
            showSearchResults: _controller.showSearchResults,
            onSearchChanged: _controller.onSearchChanged,
            onSearchResultSelected: _controller.onSearchResultSelected,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MapLocationInfoSheet(
              location: _controller.selectedLocation,
              isLoading: _controller.isLoadingAddress,
              onConfirm: () {
                if (_controller.selectedLocation != null) {
                  Navigator.of(context).pop(_controller.selectedLocation);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return MapAppBar(
      title: widget.title,
      onBackPressed: () => Navigator.pop(context),
    );
  }
}
