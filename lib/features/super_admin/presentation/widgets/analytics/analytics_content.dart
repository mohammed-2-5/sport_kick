import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/booking_status_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/city_performance_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/monthly_bookings_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/revenue_trends_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/top_fields_list.dart';

/// Analytics content widget displaying charts and performance metrics.
///
/// Shows:
/// - Revenue trends over time
/// - Booking status distribution
/// - Monthly booking trends
/// - City performance comparison
/// - Top performing fields
class AnalyticsContent extends StatelessWidget {
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final PlatformStatisticsEntity? statistics;

  const AnalyticsContent({
    super.key,
    required this.bookings,
    required this.fields,
    this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Header
          Text(
            context.l10n.platformPerformance,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.comprehensiveOverviewOfYourPlatformMetrics,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Charts
          if (bookings.isNotEmpty) ...[
            RevenueTrendsChart(bookings: bookings),
            const SizedBox(height: 32),
            BookingStatusChart(bookings: bookings),
            const SizedBox(height: 32),
            MonthlyBookingsChart(bookings: bookings),
            const SizedBox(height: 32),
            CityPerformanceChart(bookings: bookings),
            const SizedBox(height: 32),
          ] else
            _buildEmptyMessage(context, 'No booking data available'),

          if (fields.isNotEmpty) ...[
            TopFieldsList(fields: fields),
            const SizedBox(height: 32),
          ] else
            _buildEmptyMessage(context, 'No field data available'),
        ]),
      ),
    );
  }

  Widget _buildEmptyMessage(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
