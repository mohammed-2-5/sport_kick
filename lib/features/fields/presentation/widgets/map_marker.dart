import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Map marker widget for field locations.
///
/// Displays a circular pin with soccer ball icon.
class MapMarker extends StatelessWidget {
  final bool isSelected;

  const MapMarker({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Marker Pin
        Container(
          padding: EdgeInsets.all(isSelected ? 12 : 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.secondary : AppColors.primary)
                    .withValues(alpha: 0.5),
                blurRadius: isSelected ? 16 : 12,
                spreadRadius: isSelected ? 3 : 2,
              ),
            ],
            border: Border.all(color: Colors.white, width: isSelected ? 4 : 3),
          ),
          child: Icon(
            Icons.sports_soccer,
            color: Colors.white,
            size: isSelected ? 22 : 18,
          ),
        ),
        // Pin Tail
        Container(
          width: 2,
          height: isSelected ? 10 : 8,
          color: isSelected ? AppColors.secondary : AppColors.primary,
        ),
      ],
    );
  }
}
