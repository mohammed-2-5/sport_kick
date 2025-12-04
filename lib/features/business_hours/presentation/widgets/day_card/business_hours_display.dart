import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';
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

    if (!isOpen) {
      return Text(
        BusinessHoursStrings.closedAllDay,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // Check if it's 24 hours
    if (BusinessHoursFormatters.is24Hours(isOpen, openingTime, closingTime)) {
      return Row(
        children: [
          const Icon(Icons.access_time, size: 16, color: AppColors.primary),
          const SizedBox(width: BusinessHoursConstants.tinySpacing),
          Text(
            BusinessHoursStrings.open24Hours,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Show time range
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: theme.iconTheme.color?.withValues(alpha: 0.7),
        ),
        const SizedBox(width: BusinessHoursConstants.tinySpacing),
        Flexible(
          child: Text(
            BusinessHoursFormatters.formatTimeRange(openingTime, closingTime),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
