import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';

/// Reusable map view widget using OpenStreetMap tiles.
///
/// Provides a FlutterMap with:
/// - Configurable initial position and zoom
/// - OSM tile layer
/// - Position change callbacks for interactive updates
class MapView extends StatelessWidget {
  /// Controller for programmatic map manipulation.
  final MapController mapController;

  /// Initial map center position.
  final LatLng initialPosition;

  /// Callback when map camera position changes.
  final void Function(MapCamera camera, bool hasGesture) onPositionChanged;

  /// Callback when map movement ends.
  final VoidCallback onMapMoveEnd;

  /// Initial zoom level for the map.
  static const double _initialZoom = MapLocationPickerConstants.defaultZoom;

  const MapView({
    super.key,
    required this.mapController,
    required this.initialPosition,
    required this.onPositionChanged,
    required this.onMapMoveEnd,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: _initialZoom,
        minZoom: MapLocationPickerConstants.minZoom,
        maxZoom: MapLocationPickerConstants.maxZoom,
        onPositionChanged: onPositionChanged,
        onMapEvent: _handleMapEvent,
      ),
      children: [
        TileLayer(
          urlTemplate: MapLocationPickerConstants.tileUrl,
          userAgentPackageName: 'com.sportkick.app',
        ),
      ],
    );
  }

  /// Handles map events to detect move end.
  void _handleMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd) {
      onMapMoveEnd();
    }
  }
}
