import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';
import 'package:spo_kick/features/business_hours/presentation/utils/business_hours_formatters.dart';

/// Header widget for business hours day editor.
///
/// Displays day name (optional), open/closed status, and toggle switch.
class BusinessHoursEditorHeader extends StatelessWidget {
  /// Day of week (0-6)
  final int dayOfWeek;

  /// Whether the facility is open
  final bool isOpen;

  /// Callback when toggle is changed
  final ValueChanged<bool> onToggleChanged;

  /// Whether to show the day name
  final bool showDayName;

  const BusinessHoursEditorHeader({
    super.key,
    required this.dayOfWeek,
    required this.isOpen,
    required this.onToggleChanged,
    this.showDayName = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Day name
        if (showDayName) ...[
          Expanded(
            child: Text(
              BusinessHoursFormatters.getDayName(dayOfWeek),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: BusinessHoursConstants.itemSpacing),
        ],

        // Open/Closed label
        Text(
          isOpen ? BusinessHoursStrings.isOpen : BusinessHoursStrings.closed,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isOpen ? AppColors.success : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: BusinessHoursConstants.smallSpacing),

        // Toggle switch
        Transform.scale(
          scale: BusinessHoursConstants.switchScale,
          child: Switch(
            value: isOpen,
            onChanged: onToggleChanged,
            activeTrackColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}
