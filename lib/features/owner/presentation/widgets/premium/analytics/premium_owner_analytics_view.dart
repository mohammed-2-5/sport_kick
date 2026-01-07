import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_analytics_error_view.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_booking_stats_grid.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_empty_fields_message.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_performance_metrics.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_period_selector.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_revenue_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_section_title.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_top_field_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/analytics/premium_top_fields_list.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium Owner Analytics View.
///
/// Features:
/// - Premium curved header
/// - Period selector chips
/// - Revenue cards with growth indicators
/// - Booking stats grid
/// - Performance metrics carousel
/// - Top fields ranking
/// - Pull-to-refresh
class PremiumOwnerAnalyticsView extends StatefulWidget {
  const PremiumOwnerAnalyticsView({super.key});

  @override
  State<PremiumOwnerAnalyticsView> createState() =>
      _PremiumOwnerAnalyticsViewState();
}

class _PremiumOwnerAnalyticsViewState extends State<PremiumOwnerAnalyticsView> {
  String _selectedPeriod = OwnerConstants.analyticsPeriods[1];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadDashboardData(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: colorScheme.secondary,
            onRefresh: () async {
              _loadData();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PremiumCurvedHeader(
                    title: context.l10n.analytics,
                    subtitle: context.l10n.trackPerformance,
                    showBackButton: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: PremiumPeriodSelector(
                      selectedPeriod: _selectedPeriod,
                      periods: OwnerConstants.analyticsPeriods,
                      onPeriodChanged: (period) {
                        setState(() => _selectedPeriod = period);
                      },
                    ),
                  ),
                ),
                if (state is OwnerLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.secondary,
                      ),
                    ),
                  )
                else if (state is OwnerDataLoaded)
                  _buildLoadedContent(state)
                else if (state is OwnerError)
                  SliverFillRemaining(
                    child: PremiumAnalyticsErrorView(
                      message: state.message,
                      onRetry: _loadData,
                    ),
                  )
                else
                  // Show loading indicator for initial state
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.loadingAnalytics,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
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

  Widget _buildLoadedContent(OwnerDataLoaded state) {
    final revenue = state.revenue;
    final bookings = state.bookings;
    final fields = state.fields;

    final confirmedBookings = bookings
        .where((b) => b.status == BookingStatus.confirmed)
        .length;
    final pendingBookings = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;
    final canceledBookings = bookings
        .where((b) => b.status == BookingStatus.canceled)
        .length;

    final ratingsSum = fields.fold<double>(
      0.0,
      (sum, f) => sum + (f.averageRating ?? 0.0),
    );
    final avgRating = fields.isEmpty ? 0.0 : ratingsSum / fields.length;

    final completedBookings = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;
    final completionRate = bookings.isEmpty
        ? 0.0
        : (completedBookings / bookings.length) * 100;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumRevenueCard(
              totalRevenue: revenue?.totalRevenue ?? 0,
              currency: 'EGP',
              growthPercentage: revenue?.revenueGrowthRate ?? 0,
              periodLabel: _selectedPeriod,
            ),
            const SizedBox(height: 24),
            PremiumSectionTitle(title: context.l10n.bookingStatistics),
            const SizedBox(height: 12),
            PremiumBookingStatsGrid(
              totalBookings: bookings.length,
              confirmedBookings: confirmedBookings,
              pendingBookings: pendingBookings,
              canceledBookings: canceledBookings,
            ),
            const SizedBox(height: 24),
            PremiumSectionTitle(title: context.l10n.performanceMetrics),
            const SizedBox(height: 12),
            PremiumPerformanceMetrics(
              averageRating: avgRating,
              completionRate: completionRate,
              responseTime: 2.5,
              satisfactionRate: 92.0,
            ),
            const SizedBox(height: 24),
            PremiumSectionTitle(title: context.l10n.topPerformingFields),
            const SizedBox(height: 12),
            if (fields.isNotEmpty)
              PremiumTopFieldsList(
                fields: fields
                    .take(5)
                    .map(
                      (f) => TopFieldData(
                        name: f.name,
                        revenue: revenue?.revenueByField[f.id] ?? 0,
                        bookings: bookings
                            .where((b) => b.fieldId == f.id)
                            .length,
                      ),
                    )
                    .toList(),
              )
            else
              const PremiumEmptyFieldsMessage(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
