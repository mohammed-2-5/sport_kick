import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';
import 'package:flutter/material.dart';

/// Header widget for revenue analytics page.
/// Shows title and selected date range.
class RevenueAnalyticsHeader extends StatelessWidget {
  final int selectedDateRange;

  const RevenueAnalyticsHeader({super.key, required this.selectedDateRange});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.revenueAnalytics,
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
              _getDateRangeLabel(context, selectedDateRange),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDateRangeLabel(BuildContext context, int days) {
    final l10n = context.l10n;
    switch (days) {
      case AnalyticsConstants.last7Days:
        return l10n.last7Days;
      case AnalyticsConstants.last30Days:
        return l10n.last30Days;
      case AnalyticsConstants.last90Days:
        return l10n.last90Days;
      case AnalyticsConstants.lastYear:
        return l10n.lastYear;
      default:
        return l10n.last30Days;
    }
  }
}
