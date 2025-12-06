import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Header widget for revenue analytics page.
/// Shows title and selected date range.
class RevenueAnalyticsHeader extends StatelessWidget {
  final int selectedDateRange;

  const RevenueAnalyticsHeader({super.key, required this.selectedDateRange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenue Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AnalyticsConstants.metricCardSpacing),
        Row(
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              AnalyticsConstants.getDateRangeLabel(selectedDateRange),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
