import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/utils/business_hours_formatters.dart';

/// Compact content layout for business hours day card.
///
/// Displays day name (short), hours, and edit icon in a horizontal layout.
class BusinessHoursDayCardCompactContent extends StatelessWidget {
  /// Day of week (0-6)
  final int dayOfWeek;

  /// Whether the facility is open
  final bool isOpen;

  /// Opening time (HH:MM:SS format)
  final String? openingTime;

  /// Closing time (HH:MM:SS format)
  final String? closingTime;

  /// Whether this card has a tap action
  final bool hasTapAction;

  const BusinessHoursDayCardCompactContent({
    super.key,
    required this.dayOfWeek,
    required this.isOpen,
    this.openingTime,
    this.closingTime,
    this.hasTapAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // Day name (short)
        SizedBox(
          width: 40,
          child: Text(
            BusinessHoursFormatters.getDayNameShort(context, dayOfWeek),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isOpen ? null : colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        const SizedBox(width: BusinessHoursConstants.itemSpacing),

        // Status and hours
        Expanded(
          child: isOpen
              ? Text(
                  BusinessHoursFormatters.formatTimeRange(
                    context,
                    openingTime: openingTime,
                    closingTime: closingTime,
                  ),
                  style: theme.textTheme.bodySmall,
                )
              : Text(
                  context.l10n.closed,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),

        // Edit icon
        if (hasTapAction)
          Icon(
            Icons.edit_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
      ],
    );
  }
}
