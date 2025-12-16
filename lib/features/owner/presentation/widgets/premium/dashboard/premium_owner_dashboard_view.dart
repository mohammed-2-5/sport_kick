import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:spo_kick/features/notifications/presentation/cubit/notification_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/dashboard/dashboard_state_widgets.dart';
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
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    context.read<OwnerDashboardCubit>().loadDashboard();
    _notificationCubit = sl<NotificationCubit>()..loadNotifications();
  }

  @override
  void dispose() {
    _notificationCubit.close();
    super.dispose();
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
      email: '',
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
      return const DashboardLoadingState();
    }

    if (state is OwnerDashboardError) {
      return DashboardErrorState(
        message: state.message,
        onRetry: cubit.loadDashboard,
      );
    }

    if (state is OwnerDashboardLoaded) {
      return RefreshIndicator(
        onRefresh: cubit.refresh,
        color: AppColors.accentCyan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BlocBuilder<NotificationCubit, NotificationState>(
                bloc: _notificationCubit,
                builder: (context, notificationState) {
                  final unreadCount = notificationState is NotificationLoaded
                      ? notificationState.unreadCount
                      : 0;
                  return PremiumOwnerHeader(
                    greeting: cubit.getGreeting(),
                    ownerName: state.ownerName,
                    date: cubit.getFormattedDate(),
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    onNotificationTap: () => context.pushNamed('notifications'),
                    notificationCount: unreadCount,
                  );
                },
              ),
              const SizedBox(height: 20),
              PremiumOwnerStatsRow(
                totalBookings: state.stats.totalBookings,
                pendingBookings: state.stats.pendingBookings,
                todayBookings: state.stats.todayBookings,
                revenue: cubit.formatCurrency(state.stats.monthlyRevenue),
                onBookingsTap: () => context.pushNamed('ownerBookings'),
                onRevenueTap: () => context.pushNamed('ownerAnalytics'),
              ),
              const SizedBox(height: 24),
              PremiumOwnerQuickActions(
                onManualBooking: () =>
                    context.pushNamed('ownerCreateManualBooking'),
                onViewBookings: () => context.pushNamed('ownerBookings'),
                onBookingTable: () => context.pushNamed('ownerBookingTable'),
                onManageFields: () => context.pushNamed('ownerFields'),
                onAnalytics: () => context.pushNamed('ownerAnalytics'),
                onSettings: () => context.pushNamed('ownerSettings'),
                onProfile: () => context.pushNamed('ownerProfile'),
              ),
              const SizedBox(height: 24),
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
