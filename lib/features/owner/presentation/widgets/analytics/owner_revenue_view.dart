import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/analytics_error_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/analytics_loading_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/analytics/revenue_analytics_content.dart';

/// View widget for Owner Revenue Analytics.
///
/// Handles state management and displays appropriate content based on cubit state.
/// Supports date range filtering and data refresh functionality.
class OwnerRevenueView extends StatefulWidget {
  const OwnerRevenueView({super.key});

  @override
  State<OwnerRevenueView> createState() => _OwnerRevenueViewState();
}

class _OwnerRevenueViewState extends State<OwnerRevenueView> {
  int _selectedDateRange = AnalyticsConstants.defaultDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.revenueAnalytics),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          _DateRangeSelector(
            selectedDateRange: _selectedDateRange,
            onDateRangeChanged: (dateRange) {
              setState(() => _selectedDateRange = dateRange);
              _refreshData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: context.l10n.refreshFields,
          ),
        ],
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const AnalyticsLoadingState();
          }

          if (state is OwnerError) {
            return AnalyticsErrorState(
              message: state.message,
              onRetry: _refreshData,
            );
          }

          if (state is OwnerRevenueLoaded) {
            return RevenueAnalyticsContent(
              revenue: state.revenue,
              selectedDateRange: _selectedDateRange,
              onRefresh: _refreshData,
            );
          }

          return const AnalyticsLoadingState();
        },
      ),
    );
  }

  void _refreshData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadOwnerRevenue(authState.user.id);
    }
  }
}

/// Date range selector popup menu for analytics.
class _DateRangeSelector extends StatelessWidget {
  final int selectedDateRange;
  final ValueChanged<int> onDateRangeChanged;

  const _DateRangeSelector({
    required this.selectedDateRange,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<int>(
      icon: const Icon(Icons.date_range),
      tooltip: l10n.selectDate,
      onSelected: onDateRangeChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AnalyticsConstants.last7Days,
          child: Text(l10n.last7Days),
        ),
        PopupMenuItem(
          value: AnalyticsConstants.last30Days,
          child: Text(l10n.last30Days),
        ),
        PopupMenuItem(
          value: AnalyticsConstants.last90Days,
          child: Text(l10n.last90Days),
        ),
        PopupMenuItem(
          value: AnalyticsConstants.lastYear,
          child: Text(l10n.lastYear),
        ),
      ],
    );
  }
}
