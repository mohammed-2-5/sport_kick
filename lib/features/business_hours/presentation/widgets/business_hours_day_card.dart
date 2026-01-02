import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_card/business_hours_day_card_compact_content.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_card/business_hours_day_card_content.dart';

/// Card widget displaying business hours for a single day.
///
/// Shows day name, open/closed status, and operating hours.
/// Can be tapped to edit the hours for that day.
class BusinessHoursDayCard extends StatelessWidget {
  /// Business hours entity for this day
  final BusinessHoursEntity businessHours;

  /// Whether this day is currently selected for editing
  final bool isSelected;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Whether to show in compact mode (reduced size)
  final bool compact;

  const BusinessHoursDayCard({
    super.key,
    required this.businessHours,
    this.isSelected = false,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Calculate background color
    final Color backgroundColor;
    if (isSelected) {
      backgroundColor = colorScheme.primary.withValues(
        alpha: BusinessHoursConstants.selectedOpacity,
      );
    } else if (!businessHours.isOpen) {
      backgroundColor = colorScheme.surfaceContainerHighest;
    } else {
      backgroundColor = colorScheme.surface;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          BusinessHoursConstants.cardBorderRadius,
        ),
        child: Container(
          padding: EdgeInsets.all(
            compact
                ? BusinessHoursConstants.itemSpacing
                : BusinessHoursConstants.cardPadding,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              BusinessHoursConstants.cardBorderRadius,
            ),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: isDark ? 0.5 : 0.3),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: compact
              ? BusinessHoursDayCardCompactContent(
                  dayOfWeek: businessHours.dayOfWeek,
                  isOpen: businessHours.isOpen,
                  openingTime: businessHours.openingTime,
                  closingTime: businessHours.closingTime,
                  hasTapAction: onTap != null,
                )
              : BusinessHoursDayCardContent(
                  dayOfWeek: businessHours.dayOfWeek,
                  isOpen: businessHours.isOpen,
                  openingTime: businessHours.openingTime,
                  closingTime: businessHours.closingTime,
                ),
        ),
      ),
    );
  }
}
