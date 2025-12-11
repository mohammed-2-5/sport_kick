import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_drawer.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_quick_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_recent_bookings.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/premium_owner_stats_row.dart';

/// Premium owner dashboard view.
///
/// Features:
/// - Premium header with greeting
/// - Stats row with gradient cards
/// - Quick actions grid
/// - Recent bookings section
/// - Navigation drawer
/// - All logic handled by OwnerDashboardCubit
class PremiumOwnerDashboardView extends StatefulWidget {
  const PremiumOwnerDashboardView({super.key});

  @override
  State<PremiumOwnerDashboardView> createState() =>
      _PremiumOwnerDashboardViewState();
}

class _PremiumOwnerDashboardViewState extends State<PremiumOwnerDashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<OwnerDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerDashboardCubit, OwnerDashboardState>(
      listener: (context, state) {
        if (state is OwnerDashboardError) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OwnerDashboardCubit>();

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.backgroundLight,
          drawer: _buildDrawer(context, state, cubit),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    OwnerDashboardState state,
    OwnerDashboardCubit cubit,
  ) {
    if (state is! OwnerDashboardLoaded) {
      return const SizedBox.shrink();
    }

    return PremiumOwnerDrawer(
      ownerName: state.ownerName,
      email: '', // Would come from user entity
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
    OwnerDashboardState state,
    OwnerDashboardCubit cubit,
  ) {
    if (state is OwnerDashboardLoading) {
      return const _LoadingState();
    }

    if (state is OwnerDashboardError) {
      return _ErrorState(message: state.message, onRetry: cubit.loadDashboard);
    }

    if (state is OwnerDashboardLoaded) {
      return RefreshIndicator(
        onRefresh: cubit.refresh,
        color: AppColors.accentCyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              PremiumOwnerHeader(
                greeting: cubit.getGreeting(),
                ownerName: state.ownerName,
                date: cubit.getFormattedDate(),
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                onNotificationTap: () {},
                notificationCount: state.stats.pendingBookings,
              ),

              const SizedBox(height: 20),

              // Stats row
              PremiumOwnerStatsRow(
                totalBookings: state.stats.totalBookings,
                pendingBookings: state.stats.pendingBookings,
                todayBookings: state.stats.todayBookings,
                revenue: cubit.formatCurrency(state.stats.monthlyRevenue),
                onBookingsTap: () => context.pushNamed('ownerBookings'),
                onRevenueTap: () => context.pushNamed('ownerAnalytics'),
              ),

              const SizedBox(height: 24),

              // Quick actions
              PremiumOwnerQuickActions(
                onManualBooking: () =>
                    context.pushNamed('ownerCreateManualBooking'),
                onViewBookings: () => context.pushNamed('ownerBookings'),
                onManageFields: () => context.pushNamed('ownerFields'),
                onAnalytics: () => context.pushNamed('ownerAnalytics'),
                onSettings: () => context.pushNamed('ownerSettings'),
                onProfile: () => context.pushNamed('ownerProfile'),
              ),

              const SizedBox(height: 24),

              // Recent bookings
              PremiumOwnerRecentBookings(
                bookings: state.recentBookings,
                onViewAll: () => context.pushNamed('ownerBookings'),
                onBookingTap: (booking) {
                  context.pushNamed(
                    'bookingDetails',
                    pathParameters: {'id': booking.id},
                  );
                },
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
        context.pushNamed('ownerBookings');
        break;
      case 2:
        context.pushNamed('ownerFields');
        break;
      case 3:
        context.pushNamed('ownerAnalytics');
        break;
      case 4:
        context.pushNamed('ownerProfile');
        break;
      case 5:
        context.pushNamed('ownerSettings');
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
              context.goNamed('login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
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
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.accentCyan),
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
          colors: [AppColors.navyDeep, AppColors.navyLight],
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
                style: const TextStyle(fontSize: 16, color: Colors.white),
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
                    color: AppColors.accentCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
