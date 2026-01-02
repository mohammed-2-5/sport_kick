import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/utils/business_hours_formatters.dart';

/// Widget displaying the operating hours for a day.
///
/// Shows the time range when open, or indicates if closed all day or open 24 hours.
class BusinessHoursDisplay extends StatelessWidget {
  /// Whether the facility is open
  final bool isOpen;

  /// Opening time (HH:MM:SS format)
  final String? openingTime;

  /// Closing time (HH:MM:SS format)
  final String? closingTime;

  const BusinessHoursDisplay({
    super.key,
    required this.isOpen,
    this.openingTime,
    this.closingTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isOpen) {
      return Text(
        context.l10n.businessHoursClosedAllDay,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // Check if it's 24 hours
    if (BusinessHoursFormatters.is24Hours(isOpen, openingTime, closingTime)) {
      return Row(
        children: [
          Icon(Icons.access_time, size: 16, color: colorScheme.primary),
          const SizedBox(width: BusinessHoursConstants.tinySpacing),
          Text(
            context.l10n.businessHoursOpen24Hours,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Show time range
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: BusinessHoursConstants.tinySpacing),
        Flexible(
          child: Text(
            BusinessHoursFormatters.formatTimeRange(
              context,
              openingTime: openingTime,
              closingTime: closingTime,
            ),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
