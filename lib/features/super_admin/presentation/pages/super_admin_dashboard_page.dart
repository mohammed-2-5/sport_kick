import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/booking_status_row.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_drawer.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/dashboard_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/dashboard/revenue_chart.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/statistics_card.dart';

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
            return _buildErrorState(context);
          }

          if (state is PlatformStatisticsLoaded) {
            return _buildDashboardContent(context, state.statistics);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Error loading dashboard',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.premiumTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<SuperAdminCubit>().loadPlatformStatistics(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.premiumGold,
              foregroundColor: AppColors.black,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
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
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                StatisticsCard(
                  title: 'Total Users',
                  value: stats.totalUsers.toString(),
                  subtitle: '+${stats.newUsersThisMonth} this month',
                  icon: Icons.people,
                  color: Colors.blue,
                  trend: stats.userGrowthRate,
                ),
                StatisticsCard(
                  title: 'Total Admins',
                  value: stats.totalAdmins.toString(),
                  subtitle: 'Field owners',
                  icon: Icons.admin_panel_settings,
                  color: Colors.purple,
                ),
                StatisticsCard(
                  title: 'Active Fields',
                  value: stats.activeFields.toString(),
                  subtitle: '${stats.inactiveFields} inactive',
                  icon: Icons.sports_soccer,
                  color: Colors.green,
                ),
                StatisticsCard(
                  title: 'Total Bookings',
                  value: stats.totalBookings.toString(),
                  subtitle: '${stats.pendingBookings} pending',
                  icon: Icons.event,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Revenue Stats Row
            Row(
              children: [
                Expanded(
                  child: StatisticsCard(
                    title: 'Total Revenue',
                    value: 'EGP ${stats.formattedRevenue}',
                    subtitle: 'All time earnings',
                    icon: Icons.monetization_on,
                    color: AppColors.premiumGold,
                    trend: stats.revenueGrowthRate,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatisticsCard(
                    title: 'Avg. Revenue',
                    value:
                        'EGP ${stats.averageRevenuePerBooking.toStringAsFixed(0)}',
                    subtitle: 'Per booking',
                    icon: Icons.analytics,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),

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
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.premiumTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildQuickActionCard(
                  context,
                  'Create Admin',
                  'Add new field owner',
                  Icons.person_add,
                  Colors.purple,
                  'superAdminCreateAdmin',
                ),
                _buildQuickActionCard(
                  context,
                  'Create Field',
                  'Add new sports field',
                  Icons.add_business,
                  Colors.deepOrange,
                  'superAdminCreateField',
                ),
                _buildQuickActionCard(
                  context,
                  'View Admins',
                  'Manage field owners',
                  Icons.admin_panel_settings,
                  Colors.blue,
                  'superAdminAdmins',
                ),
                _buildQuickActionCard(
                  context,
                  'View Users',
                  'Manage customers',
                  Icons.people,
                  Colors.green,
                  'superAdminUsers',
                ),
                _buildQuickActionCard(
                  context,
                  'Manage Cities',
                  'Configure locations',
                  Icons.location_city,
                  Colors.orange,
                  'superAdminCities',
                ),
                _buildQuickActionCard(
                  context,
                  'All Fields',
                  'View all sports fields',
                  Icons.sports_soccer,
                  Colors.teal,
                  'superAdminFields',
                ),
                _buildQuickActionCard(
                  context,
                  'All Bookings',
                  'View all reservations',
                  Icons.event_note,
                  Colors.indigo,
                  'superAdminBookings',
                ),
                _buildQuickActionCard(
                  context,
                  'Analytics',
                  'Platform insights',
                  Icons.analytics,
                  Colors.deepPurple,
                  'superAdminAnalytics',
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return InkWell(
      onTap: () => context.pushNamed(route),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.premiumSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.premiumTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.premiumTextSecondary,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
