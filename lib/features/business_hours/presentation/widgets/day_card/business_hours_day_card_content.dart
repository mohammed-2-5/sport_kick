import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/utils/business_hours_formatters.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_card/business_hours_display.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_card/business_hours_status_badge.dart';

/// Full content layout for business hours day card.
///
/// Displays day name, status badge, and hours in a vertical layout.
class BusinessHoursDayCardContent extends StatelessWidget {
  /// Day of week (0-6)
  final int dayOfWeek;

  /// Whether the facility is open
  final bool isOpen;

  /// Opening time (HH:MM:SS format)
  final String? openingTime;

  /// Closing time (HH:MM:SS format)
  final String? closingTime;

  const BusinessHoursDayCardContent({
    super.key,
    required this.dayOfWeek,
    required this.isOpen,
    this.openingTime,
    this.closingTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Day name
        Text(
          BusinessHoursFormatters.getDayName(context, dayOfWeek),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isOpen ? null : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: BusinessHoursConstants.smallSpacing),

        // Status badge
        BusinessHoursStatusBadge(isOpen: isOpen),

        const SizedBox(height: BusinessHoursConstants.smallSpacing),

        // Hours display
        BusinessHoursDisplay(
          isOpen: isOpen,
          openingTime: openingTime,
          closingTime: closingTime,
        ),
      ],
    );
  }
}
