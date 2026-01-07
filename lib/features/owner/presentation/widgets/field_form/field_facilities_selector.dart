import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

class FieldFacilitiesSelector extends StatelessWidget {
  final List<String> selectedFacilities;
  final ValueChanged<String> onFacilityToggled;

  const FieldFacilitiesSelector({
    required this.selectedFacilities,
    required this.onFacilityToggled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: OwnerConstants.facilities.map((facility) {
        final isSelected = selectedFacilities.contains(facility);
        return GestureDetector(
          onTap: () => onFacilityToggled(facility),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected ? AppGradients.primary : null,
              color: isSelected
                  ? null
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.outlineVariant,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFacilityIcon(facility),
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _getFacilityLabel(context, facility),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getFacilityLabel(BuildContext context, String facility) {
    switch (facility) {
      case 'Parking':
        return context.l10n.parking;
      case 'Changing Room':
        return context.l10n.changingRooms;
      case 'Shower':
        return context.l10n.showers;
      case 'Cafeteria':
        return context.l10n.cafeteria;
      case 'WiFi':
        return context.l10n.wifi;
      case 'Lighting':
        return context.l10n.lighting;
      default:
        return facility;
    }
  }

  IconData _getFacilityIcon(String facility) {
    switch (facility) {
      case 'Parking':
        return Icons.local_parking_rounded;
      case 'Changing Room':
        return Icons.checkroom_rounded;
      case 'Shower':
        return Icons.shower_rounded;
      case 'Cafeteria':
        return Icons.restaurant_rounded;
      case 'WiFi':
        return Icons.wifi_rounded;
      case 'Lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
