import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_booking_status_chart.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_by_field_chart.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_metrics.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/owner_revenue_trends_chart.dart';

/// Owner Revenue Analytics Page
///
/// Displays comprehensive revenue analytics for field owners:
/// - Revenue trends over time
/// - Revenue breakdown by field
/// - Booking status distribution
/// - Key performance metrics
/// - Date range filtering
class OwnerRevenuePage extends StatelessWidget {
  const OwnerRevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthCubit>().state;
        if (authState is Authenticated) {
          return sl<OwnerCubit>()..loadOwnerRevenue(authState.user.id);
        }
        return sl<OwnerCubit>();
      },
      child: const _OwnerRevenueView(),
    );
  }
}

class _OwnerRevenueView extends StatefulWidget {
  const _OwnerRevenueView();

  @override
  State<_OwnerRevenueView> createState() => _OwnerRevenueViewState();
}

class _OwnerRevenueViewState extends State<_OwnerRevenueView> {
  int _selectedDateRange = AnalyticsConstants.defaultDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Analytics'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.date_range),
            tooltip: 'Select Date Range',
            onSelected: (dateRange) {
              setState(() {
                _selectedDateRange = dateRange;
              });
              _refreshData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AnalyticsConstants.last7Days,
                child: Text(AnalyticsConstants.last7DaysLabel),
              ),
              const PopupMenuItem(
                value: AnalyticsConstants.last30Days,
                child: Text(AnalyticsConstants.last30DaysLabel),
              ),
              const PopupMenuItem(
                value: AnalyticsConstants.last90Days,
                child: Text(AnalyticsConstants.last90DaysLabel),
              ),
              const PopupMenuItem(
                value: AnalyticsConstants.lastYear,
                child: Text(AnalyticsConstants.lastYearLabel),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return _buildLoadingState();
          }

          if (state is OwnerError) {
            return _buildErrorState(state.message);
          }

          if (state is OwnerRevenueLoaded) {
            return _buildAnalyticsContent(state);
          }

          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AnalyticsConstants.sectionSpacing),
          Text('Loading analytics...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AnalyticsConstants.emptyStateIconSize,
            color: Colors.red,
          ),
          const SizedBox(height: AnalyticsConstants.sectionSpacing),
          const Text(
            'Error loading analytics',
            style: TextStyle(
              fontSize: AnalyticsConstants.chartTitleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AnalyticsConstants.metricCardSpacing),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AnalyticsConstants.sectionSpacing),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(OwnerRevenueLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AnalyticsConstants.pageContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: AnalyticsConstants.sectionSpacing),

            // Key Metrics
            OwnerRevenueMetrics(revenue: state.revenue),
            const SizedBox(height: AnalyticsConstants.chartSpacing),

            // Revenue Trends Chart
            OwnerRevenueTrendsChart(
              revenue: state.revenue,
              dateRangeDays: _selectedDateRange,
            ),
            const SizedBox(height: AnalyticsConstants.chartSpacing),

            // Revenue by Field Chart
            if (state.revenue.revenueByField.isNotEmpty) ...[
              OwnerRevenueByFieldChart(
                revenueByField: state.revenue.revenueByField,
              ),
              const SizedBox(height: AnalyticsConstants.chartSpacing),
            ],

            // Booking Status Chart
            OwnerBookingStatusChart(revenue: state.revenue),
            const SizedBox(height: AnalyticsConstants.sectionSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            const Icon(Icons.date_range, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              AnalyticsConstants.getDateRangeLabel(_selectedDateRange),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  void _refreshData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadOwnerRevenue(authState.user.id);
    }
  }
}
