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

/// Super Admin Dashboard Page - Premium Design
///
/// Displays comprehensive platform statistics:
/// - User & Admin counts
/// - Field statistics
/// - Booking metrics & status breakdown
/// - Revenue analytics with trends chart
/// - 8 Quick action shortcuts
class SuperAdminDashboardPage extends StatelessWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SuperAdminDashboardView();
  }
}

class _SuperAdminDashboardView extends StatelessWidget {
  const _SuperAdminDashboardView();

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
            return Center(
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
            return _buildDashboardContent(context, state.statistics);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, dynamic stats) {
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
            DashboardMainStatsGrid(statistics: stats),

            const SizedBox(height: 16),

            // Revenue Stats Row
            DashboardRevenueRow(statistics: stats),

            const SizedBox(height: 16),

            // Booking Status Row
            BookingStatusRow(statistics: stats),

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
              revenueData: stats.dailyRevenue.isNotEmpty
                  ? stats.dailyRevenue
                  : const [0, 0, 0, 0, 0, 0, 0],
              labels: stats.revenueDateLabels,
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
