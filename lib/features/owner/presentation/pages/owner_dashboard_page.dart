import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/dashboard_quick_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard_stats_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/recent_bookings_section.dart';
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
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      final ownerId = authState.user.id;
      context.read<OwnerCubit>().loadOwnerFields(ownerId);
      context.read<OwnerCubit>().loadOwnerBookings(ownerId: ownerId);
      context.read<OwnerCubit>().loadOwnerRevenue(ownerId);
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
        onRefresh: () async => _loadDashboardData(),
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
                  _buildStatsSection(state),

                  const SizedBox(height: 32),

                  // Quick Actions
                  DashboardQuickActions(
                    onManualBooking: () async {
                      final result = await context.pushNamed(
                        'ownerCreateManualBooking',
                      );
                      if (result == true && mounted) {
                        _loadDashboardData();
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
                  _buildRecentBookingsSection(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsSection(OwnerState state) {
    if (state is OwnerLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Extract data from OwnerDataLoaded state
    final bookings = state is OwnerDataLoaded
        ? state.bookings
        : (state is OwnerBookingsLoaded ? state.bookings : <BookingEntity>[]);
    final fields = state is OwnerDataLoaded
        ? state.fields
        : (state is OwnerFieldsLoaded ? state.fields : <FieldEntity>[]);
    final revenue = state is OwnerDataLoaded
        ? (state.revenue?.totalRevenue ?? 0.0)
        : (state is OwnerRevenueLoaded ? state.revenue.totalRevenue : 0.0);

    return DashboardStatsSection(
      bookings: bookings,
      fields: fields,
      revenue: revenue,
    );
  }

  Widget _buildRecentBookingsSection(OwnerState state) {
    if (state is OwnerLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bookings = state is OwnerDataLoaded
        ? state.bookings
        : (state is OwnerBookingsLoaded ? state.bookings : <BookingEntity>[]);

    return RecentBookingsSection(
      bookings: bookings,
      onViewAll: () {
        context.pushNamed('ownerBookings');
      },
    );
  }
}
