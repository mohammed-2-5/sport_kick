import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/booking_status_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/city_performance_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/monthly_bookings_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/revenue_trends_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/top_fields_list.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Platform Analytics Page
///
/// Comprehensive analytics dashboard for super admin showing:
/// - Revenue trends over time
/// - Booking status distribution
/// - City performance comparison
/// - Top performing fields
/// - Monthly booking trends
class PlatformAnalyticsPage extends StatelessWidget {
  const PlatformAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAnalyticsData(),
      child: const _PlatformAnalyticsView(),
    );
  }
}

class _PlatformAnalyticsView extends StatelessWidget {
  const _PlatformAnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<SuperAdminCubit, SuperAdminState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.goldAccent,
            onRefresh: () async {
              context.read<SuperAdminCubit>().loadAnalyticsData();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: context.l10n.analytics,
                    subtitle: context.l10n.platformPerformanceMetrics,
                    showBackButton: true,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.read<SuperAdminCubit>().loadAnalyticsData();
                        },
                      ),
                    ],
                  ),
                ),
                if (state is SuperAdminLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                      ),
                    ),
                  )
                else if (state is SuperAdminError)
                  SliverFillRemaining(
                    child: _ErrorContent(
                      message: state.message,
                      onRetry: () =>
                          context.read<SuperAdminCubit>().loadAnalyticsData(),
                    ),
                  )
                else if (state is AnalyticsDataLoaded)
                  _AnalyticsContent(
                    bookings: state.bookings,
                    fields: state.fields,
                    statistics: state.statistics,
                  )
                else
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final PlatformStatisticsEntity? statistics;

  const _AnalyticsContent({
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
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
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
            _buildEmptyMessage('No booking data available'),

          if (fields.isNotEmpty) ...[
            TopFieldsList(fields: fields),
            const SizedBox(height: 32),
          ] else
            _buildEmptyMessage('No field data available'),
        ]),
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorLoadingAnalytics,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navyDeep,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
