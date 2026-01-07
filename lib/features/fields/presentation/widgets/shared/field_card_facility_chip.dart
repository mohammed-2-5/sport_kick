import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_data.dart';
import 'package:spo_kick/features/fields/presentation/utils/facility_localizer.dart';

/// Single facility chip with gradient background and icon.
class FieldCardFacilityChip extends StatelessWidget {
  /// The facility name
  final String facility;

  const FieldCardFacilityChip({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradient = FacilityData.getGradient(facility, colorScheme);
    final displayName = FacilityLocalizer.localize(context, facility);
    final contentColor = colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FacilityData.getIcon(facility), size: 12, color: contentColor),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
