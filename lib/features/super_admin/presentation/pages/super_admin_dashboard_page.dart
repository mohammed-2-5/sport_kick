import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/statistics_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/quick_action_card.dart';

/// Super Admin Dashboard Page
///
/// Main dashboard for super admin showing:
/// - Platform statistics (users, admins, fields, bookings, revenue)
/// - Quick actions (create admin, view lists, manage platform)
/// - Recent activity feed
class SuperAdminDashboardPage extends StatelessWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadPlatformStatistics(),
      child: const _SuperAdminDashboardView(),
    );
  }
}

class _SuperAdminDashboardView extends StatelessWidget {
  const _SuperAdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SuperAdminCubit>().loadPlatformStatistics();
            },
            tooltip: 'Refresh Statistics',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SuperAdminLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is SuperAdminError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SuperAdminCubit>().loadPlatformStatistics();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PlatformStatisticsLoaded) {
            final stats = state.statistics;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SuperAdminCubit>().loadPlatformStatistics();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Text(
                      'Platform Overview',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monitor and manage your sports booking platform',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // Statistics Cards Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
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

                    // Revenue and Bookings Stats
                    Row(
                      children: [
                        Expanded(
                          child: StatisticsCard(
                            title: 'Total Revenue',
                            value: 'EGP ${stats.formattedRevenue}',
                            subtitle: 'All time earnings',
                            icon: Icons.monetization_on,
                            color: Colors.teal,
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
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStatCard(
                            label: 'Confirmed',
                            value: stats.confirmedBookings.toString(),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniStatCard(
                            label: 'Completed',
                            value: stats.completedBookings.toString(),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniStatCard(
                            label: 'Cancelled',
                            value: stats.canceledBookings.toString(),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Quick Actions Section
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        QuickActionCard(
                          title: 'Create Admin',
                          subtitle: 'Add new field owner',
                          icon: Icons.person_add,
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/super-admin/create-admin',
                            );
                          },
                        ),
                        QuickActionCard(
                          title: 'View Admins',
                          subtitle: 'Manage field owners',
                          icon: Icons.admin_panel_settings,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pushNamed(context, '/super-admin/admins');
                          },
                        ),
                        QuickActionCard(
                          title: 'View Users',
                          subtitle: 'Manage customers',
                          icon: Icons.people,
                          color: Colors.green,
                          onTap: () {
                            Navigator.pushNamed(context, '/super-admin/users');
                          },
                        ),
                        QuickActionCard(
                          title: 'Manage Cities',
                          subtitle: 'Configure locations',
                          icon: Icons.location_city,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pushNamed(context, '/super-admin/cities');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }

          // Initial or unknown state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Super Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sport Kick Platform',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Create Admin'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/super-admin/create-admin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('View Admins'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/super-admin/admins');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('View Users'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/super-admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Manage Cities'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/super-admin/cities');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Perform logout
              context.read<AuthCubit>().logout();
              // Navigate to login page
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// Mini statistics card for booking status
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
