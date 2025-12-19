import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Location section widget for field details.
///
/// Displays:
/// - Address and city
/// - Interactive map (if coordinates available)
class FieldLocationSection extends StatelessWidget {
  final FieldEntity field;

  const FieldLocationSection({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.location,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: FieldConstants.itemSpacing),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.error, size: 20),
              const SizedBox(width: FieldConstants.chipSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.address,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      field.city,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (field.hasLocation) ...[
            const SizedBox(height: FieldConstants.itemSpacing),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                FieldConstants.imageBorderRadius,
              ),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(field.latitude!, field.longitude!),
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.spo_kick',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(field.latitude!, field.longitude!),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: AppColors.error,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
