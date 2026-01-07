import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/widgets/map/map_location_picker_widgets.dart';

/// Widget containing map control buttons and visual markers.
///
/// Displays:
/// - Center marker (draggable location picker crosshair)
/// - Current location FAB (button to jump to device location)
///
/// The center marker is positioned at the map center regardless of scrolling.
/// The location FAB is positioned in the bottom-right corner of the map.
///
/// Called by [MapLocationPicker] to render interactive controls over the map.
class MapControls extends StatelessWidget {
  /// Callback invoked when "My Location" button is pressed.
  ///
  /// Should fetch device location and center map on it.
  final VoidCallback onGetCurrentLocation;

  const MapControls({super.key, required this.onGetCurrentLocation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Center marker (draggable location picker)
        _buildCenterMarker(),

        // My location FAB
        _buildLocationFab(),
      ],
    );
  }

  /// Builds the center marker widget.
  ///
  /// Positioned at the exact center of the map screen (accounting for bottom sheet).
  /// Displays the [MapLocationMarker] which shows a location pin with stem.
  /// User drags/moves the map to reposition the marker and select a location.
  Widget _buildCenterMarker() {
    return const Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: MapLocationPickerConstants.bottomSheetHeight,
      child: Center(child: MapLocationMarker()),
    );
  }

  /// Builds the current location floating action button.
  ///
  /// Positioned in the bottom-right corner above the location info sheet.
  /// Icon: [Icons.my_location]
  /// Color: Cyan on white background
  /// Size: Mini FAB (40x40)
  Widget _buildLocationFab() {
    return Positioned(
      right: MapLocationPickerConstants.horizontalPadding,
      bottom: MapLocationPickerConstants.bottomSheetHeight + 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: AppColors.surfaceWhite,
        onPressed: onGetCurrentLocation,
        tooltip: MapLocationPickerConstants.myLocationTooltip,
        child: const Icon(Icons.my_location, color: AppColors.accentCyan),
      ),
    );
  }
}
