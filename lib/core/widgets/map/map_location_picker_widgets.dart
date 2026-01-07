import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';

/// Search result item widget for location picker.
///
/// Displays address with icon in a tappable list item format.
class MapSearchResultItem extends StatelessWidget {
  /// The location data to display.
  final LocationData location;

  /// Callback when this search result is tapped.
  final VoidCallback onTap;

  /// Icon size for the location marker.
  static const double _iconSize = 20;

  /// Padding between icon and text.
  static const double _iconTextSpacing = 12;

  /// Icon padding within its container.
  static const double _iconPadding = 8;

  /// Icon container border radius.
  static const double _iconBorderRadius = 8;

  const MapSearchResultItem({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: MapLocationPickerConstants.horizontalPadding,
          vertical: MapLocationPickerConstants.verticalPadding,
        ),
        child: Row(
          children: [
            _buildLocationIcon(),
            const SizedBox(width: _iconTextSpacing),
            Expanded(
              child: Text(
                location.address,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.lightTextPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the location icon with cyan background.
  Widget _buildLocationIcon() {
    return Container(
      padding: const EdgeInsets.all(_iconPadding),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(_iconBorderRadius),
      ),
      child: const Icon(
        Icons.location_on,
        color: AppColors.accentCyan,
        size: _iconSize,
      ),
    );
  }
}

/// Animated location marker widget for map display.
///
/// Shows a circle with location icon and a stem line below it.
/// Used as the center marker in the map location picker.
class MapLocationMarker extends StatelessWidget {
  /// Size for the location icon.
  static const double _iconSize = 24;

  /// Padding around the icon.
  static const double _iconPadding = 8;

  /// Height of the stem line below the marker.
  static const double _stemHeight = 20;

  /// Width of the stem line.
  static const double _stemWidth = 2;

  const MapLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMarkerCircle(),
        CustomPaint(
          size: const Size(_stemWidth, _stemHeight),
          painter: _MarkerStemPainter(),
        ),
      ],
    );
  }

  /// Builds the circular marker with icon and shadow.
  Widget _buildMarkerCircle() {
    return Container(
      padding: const EdgeInsets.all(_iconPadding),
      decoration: BoxDecoration(
        color: AppColors.accentCyan,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: _iconSize,
      ),
    );
  }
}

/// Custom painter for the stem line of the location marker.
class _MarkerStemPainter extends CustomPainter {
  /// Stroke width for the stem line.
  static const double _strokeWidth = 2;

  /// Radius of the dot at the bottom.
  static const double _dotRadius = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw vertical line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Draw dot at bottom
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      _dotRadius,
      Paint()..color = AppColors.accentCyan,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
