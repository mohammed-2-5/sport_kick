import 'package:flutter/material.dart';

/// Map marker widget for field locations.
///
/// Displays a circular pin with soccer ball icon.
class MapMarker extends StatelessWidget {
  final bool isSelected;

  const MapMarker({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final markerColor = isSelected
        ? colorScheme.secondary
        : colorScheme.primary;
    // Use surface for border to provide contrast in both light and dark themes
    final borderColor = colorScheme.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Marker Pin
        Container(
          padding: EdgeInsets.all(isSelected ? 12 : 10),
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: markerColor.withValues(alpha: 0.5),
                blurRadius: isSelected ? 16 : 12,
                spreadRadius: isSelected ? 3 : 2,
              ),
            ],
            border: Border.all(color: borderColor, width: isSelected ? 4 : 3),
          ),
          child: Icon(
            Icons.sports_soccer,
            color: colorScheme.onPrimary,
            size: isSelected ? 22 : 18,
          ),
        ),
        // Pin Tail
        Container(width: 2, height: isSelected ? 10 : 8, color: markerColor),
      ],
    );
  }
}
