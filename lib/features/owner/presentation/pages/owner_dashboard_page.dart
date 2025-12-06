import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/dashboard_quick_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/dashboard_recent_bookings_section_wrapper.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/dashboard_stats_section_wrapper.dart';
import 'package:spo_kick/features/owner/presentation/widgets/welcome_header.dart';

/// Owner Dashboard - Main hub for field owners
///
/// Features:
/// - View key statistics (bookings, revenue, fields)
/// - Quick actions (manage bookings, manage fields, analytics)
/// - Recent bookings overview
/// - Performance metrics
class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data using cubit
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadDashboardData(authState.user.id);
    }
  }

  void _refreshDashboard() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadDashboardData(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshDashboard(),
        child: BlocBuilder<OwnerCubit, OwnerState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  const WelcomeHeader(),

                  const SizedBox(height: 24),

                  // Statistics Cards
                  DashboardStatsSectionWrapper(state: state),

                  const SizedBox(height: 32),

                  // Quick Actions
                  DashboardQuickActions(
                    onManualBooking: () async {
                      final result = await context.pushNamed(
                        'ownerCreateManualBooking',
                      );
                      if (result == true && mounted) {
                        _refreshDashboard();
                      }
                    },
                    onManageBookings: () {
                      context.pushNamed('ownerBookings');
                    },
                    onManageFields: () {
                      context.pushNamed('ownerFields');
                    },
                    onAnalytics: () {
                      context.pushNamed('ownerAnalytics');
                    },
                    onSettings: () {
                      context.pushNamed('ownerSettings');
                    },
                  ),

                  const SizedBox(height: 32),

                  // Recent Bookings Section
                  DashboardRecentBookingsSectionWrapper(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
