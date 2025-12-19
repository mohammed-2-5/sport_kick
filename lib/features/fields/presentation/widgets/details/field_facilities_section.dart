import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Facilities section widget for field details.
///
/// Displays a grid of facility chips with icons.
class FieldFacilitiesSection extends StatelessWidget {
  final FieldEntity field;

  const FieldFacilitiesSection({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    if (!field.hasFacilities) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.facilities,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: FieldConstants.itemSpacing),
          Wrap(
            spacing: FieldConstants.itemSpacing,
            runSpacing: FieldConstants.itemSpacing,
            children: field.facilities
                .map(
                  (facility) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getFacilityIcon(facility),
                          size: FieldConstants.facilityIconSize,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: FieldConstants.chipSpacing),
                        Text(
                          FacilityLocalizer.localize(context, facility),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    final lowerFacility = facility.toLowerCase();
    if (lowerFacility.contains('parking')) return Icons.local_parking;
    if (lowerFacility.contains('shower')) return Icons.shower;
    if (lowerFacility.contains('changing')) return Icons.checkroom;
    if (lowerFacility.contains('light') || lowerFacility.contains('flood')) {
      return Icons.lightbulb;
    }
    if (lowerFacility.contains('cafe') || lowerFacility.contains('food')) {
      return Icons.restaurant;
    }
    if (lowerFacility.contains('air') || lowerFacility.contains('ac')) {
      return Icons.ac_unit;
    }
    if (lowerFacility.contains('wifi')) return Icons.wifi;
    if (lowerFacility.contains('locker')) return Icons.lock;
    return Icons.check_circle;
  }
}
