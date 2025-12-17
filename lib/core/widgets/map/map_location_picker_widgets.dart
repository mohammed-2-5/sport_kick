import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/map_location_picker_constants.dart';
import 'package:spo_kick/core/models/location_data.dart';

/// Search result item widget for location picker.
class MapSearchResultItem extends StatelessWidget {
  final LocationData location;
  final VoidCallback onTap;

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.accentCyan,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
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
}

/// Animated location marker for map.
class MapLocationMarker extends StatelessWidget {
  const MapLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
          child: const Icon(Icons.location_on, color: Colors.white, size: 24),
        ),
        CustomPaint(size: const Size(2, 20), painter: _MarkerStemPainter()),
      ],
    );
  }
}

class _MarkerStemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Draw dot at bottom
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      3,
      Paint()..color = AppColors.accentCyan,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bottom sheet showing selected location info.
class MapLocationInfoSheet extends StatelessWidget {
  final LocationData? location;
  final bool isLoading;
  final VoidCallback onConfirm;

  const MapLocationInfoSheet({
    super.key,
    required this.location,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MapLocationPickerConstants.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(MapLocationPickerConstants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.disabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location info
            if (isLoading)
              const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (location != null) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.cyanGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location!.address.split(',').first,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          location!.coordinatesString,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Confirm button
            ElevatedButton(
              onPressed: location != null && !isLoading ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                MapLocationPickerConstants.confirmButton,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
