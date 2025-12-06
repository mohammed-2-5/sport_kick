import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/booking_status_row.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_drawer.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_error_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_main_stats_grid.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_quick_actions_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_revenue_row.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/revenue_chart.dart';

/// Super Admin Dashboard View - Main content widget
///
/// Handles the scaffold, drawer, and state-based content rendering.
class SuperAdminDashboardView extends StatelessWidget {
  const SuperAdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      drawer: const DashboardDrawer(),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.premiumGold),
            );
          }

          if (state is SuperAdminError) {
            return DashboardErrorState(
              onRetry: () =>
                  context.read<SuperAdminCubit>().loadPlatformStatistics(),
            );
          }

          if (state is PlatformStatisticsLoaded) {
            return _DashboardContent(statistics: state.statistics);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Dashboard content widget - displays all stats and charts
class _DashboardContent extends StatelessWidget {
  final dynamic statistics;

  const _DashboardContent({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.premiumGold,
      backgroundColor: AppColors.premiumSurface,
      onRefresh: () async {
        context.read<SuperAdminCubit>().loadPlatformStatistics();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const DashboardHeader(),
            const SizedBox(height: 32),

            // Main Statistics Grid (2x2)
            DashboardMainStatsGrid(statistics: statistics),

            const SizedBox(height: 16),

            // Revenue Stats Row
            DashboardRevenueRow(statistics: statistics),

            const SizedBox(height: 16),

            // Booking Status Row
            BookingStatusRow(statistics: statistics),

            const SizedBox(height: 32),

            // Revenue Trends Chart
            Text(
              'Revenue Trends',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.premiumTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            RevenueChart(
              revenueData: statistics.dailyRevenue.isNotEmpty
                  ? statistics.dailyRevenue
                  : const [0, 0, 0, 0, 0, 0, 0],
              labels: statistics.revenueDateLabels,
            ),

            const SizedBox(height: 32),

            // Quick Actions
            const DashboardQuickActionsSection(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
