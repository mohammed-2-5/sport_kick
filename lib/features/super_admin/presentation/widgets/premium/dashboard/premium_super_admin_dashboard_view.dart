import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_activity_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_drawer.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_quick_actions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_revenue_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/dashboard/premium_super_admin_stats_grid.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium super admin dashboard view.
///
/// Features:
/// - Gold-themed premium header
/// - Platform statistics grid
/// - Revenue card
/// - Quick actions
/// - Today's activity
/// - Navigation drawer
/// - All logic handled by SuperAdminDashboardCubit
class PremiumSuperAdminDashboardView extends StatefulWidget {
  const PremiumSuperAdminDashboardView({super.key});

  @override
  State<PremiumSuperAdminDashboardView> createState() =>
      _PremiumSuperAdminDashboardViewState();
}

class _PremiumSuperAdminDashboardViewState
    extends State<PremiumSuperAdminDashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<SuperAdminDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuperAdminDashboardCubit, SuperAdminDashboardState>(
      listener: (context, state) {
        if (state is SuperAdminDashboardError) {
          SnackbarHelper.showError(
            context,
            context.l10n.errorLoadingDashboard(state.message),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SuperAdminDashboardCubit>();

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).colorScheme.surface,
          drawer: _buildDrawer(context, state, cubit),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    SuperAdminDashboardState state,
    SuperAdminDashboardCubit cubit,
  ) {
    if (state is! SuperAdminDashboardLoaded) {
      return const SizedBox.shrink();
    }

    return PremiumSuperAdminDrawer(
      adminName: state.adminName,
      email: 'admin@sportkick.com',
      selectedIndex: state.selectedNavIndex,
      onItemTap: (index) {
        Navigator.pop(context);
        _handleDrawerNavigation(context, index);
      },
      onLogout: () => _handleLogout(context),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SuperAdminDashboardState state,
    SuperAdminDashboardCubit cubit,
  ) {
    if (state is SuperAdminDashboardLoading) {
      return const _LoadingState();
    }

    if (state is SuperAdminDashboardError) {
      return _ErrorState(message: state.message, onRetry: cubit.loadDashboard);
    }

    if (state is SuperAdminDashboardLoaded) {
      return RefreshIndicator(
        onRefresh: cubit.refresh,
        color: AppColors.goldAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              PremiumSuperAdminHeader(
                greeting: cubit.getGreeting(),
                adminName: state.adminName,
                date: cubit.getFormattedDate(),
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                onNotificationTap: () {},
                notificationCount: state.stats.pendingBookings,
              ),

              const SizedBox(height: 20),

              // Stats grid
              PremiumSuperAdminStatsGrid(
                totalUsers: state.stats.totalUsers,
                totalAdmins: state.stats.totalAdmins,
                totalFields: state.stats.totalFields,
                totalBookings: state.stats.totalBookings,
                userGrowth: cubit.getUserGrowthPercentage(),
                bookingGrowth: cubit.getBookingGrowthPercentage(),
                onUsersTap: () => context.pushNamed('superAdminUsers'),
                onAdminsTap: () => context.pushNamed('superAdminAdmins'),
                onFieldsTap: () => context.pushNamed('superAdminFields'),
                onBookingsTap: () => context.pushNamed('superAdminBookings'),
              ),

              const SizedBox(height: 20),

              // Revenue card
              PremiumSuperAdminRevenueCard(
                totalRevenue: cubit.formatCurrency(state.stats.totalRevenue),
                monthlyRevenue: cubit.formatCurrency(
                  state.stats.revenueThisMonth,
                ),
                weeklyRevenue: cubit.formatCurrency(
                  state.stats.dailyRevenue.isNotEmpty
                      ? state.stats.dailyRevenue.reduce((a, b) => a + b) * 1000
                      : 0,
                ),
                growthPercentage: cubit.getRevenueGrowthPercentage(),
                onTap: () => context.pushNamed('superAdminAnalytics'),
              ),

              const SizedBox(height: 24),

              // Quick actions
              PremiumSuperAdminQuickActions(
                onManageUsers: () => context.pushNamed('superAdminUsers'),
                onManageAdmins: () => context.pushNamed('superAdminAdmins'),
                onManageFields: () => context.pushNamed('superAdminFields'),
                onManageBookings: () => context.pushNamed('superAdminBookings'),
                onManageCities: () => context.pushNamed('superAdminCities'),
                onViewAnalytics: () => context.pushNamed('superAdminAnalytics'),
                onViewReports: () => context.pushNamed('superAdminReports'),
                onSettings: () => context.pushNamed('superAdminSettings'),
              ),

              const SizedBox(height: 24),

              // Today's activity
              PremiumSuperAdminActivityCard(
                todayBookings: state.stats.bookingsThisMonth,
                pendingBookings: state.stats.pendingBookings,
                pendingFields:
                    state.stats.totalFields - state.stats.activeFields,
                activeUsers: state.stats.totalUsers,
                onTap: () => context.pushNamed('superAdminBookings'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _handleDrawerNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        context.pushNamed('superAdminUsers');
        break;
      case 2:
        context.pushNamed('superAdminAdmins');
        break;
      case 3:
        context.pushNamed('superAdminFields');
        break;
      case 4:
        context.pushNamed('superAdminBookings');
        break;
      case 5:
        context.pushNamed('superAdminCities');
        break;
      case 6:
        context.pushNamed('manageSportCategories');
        break;
      case 7:
        context.pushNamed('manageReviews');
        break;
      case 8:
        context.pushNamed('manageNotifications');
        break;
      case 9:
        context.pushNamed('superAdminAnalytics');
        break;
      case 10:
        context.pushNamed('superAdminReports');
        break;
      case 11:
        context.pushNamed('superAdminLoginActivity');
        break;
      case 12:
        context.pushNamed('superAdminSettings');
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
              context.goNamed('login');
            },
            child: Text(
              context.l10n.logout,
              style: AppTextStyles.withColor(
                AppTextStyles.labelMedium,
                AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.goldAccent),
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLargeWhite,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.goldAccent, Color(0xFFD4A574)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.retry,
                        style: AppTextStyles.labelLargeWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
