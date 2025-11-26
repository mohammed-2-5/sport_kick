import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard_stats_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/quick_action_card.dart';
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
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
          ),
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
                  _buildQuickActions(),

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

    // Extract data from different state types
    final bookings = state is OwnerBookingsLoaded
        ? state.bookings
        : <BookingEntity>[];
    final fields = state is OwnerFieldsLoaded
        ? state.fields
        : <FieldEntity>[];
    final revenue = state is OwnerRevenueLoaded
        ? state.revenue.totalRevenue
        : 0.0;

    return DashboardStatsSection(
      bookings: bookings,
      fields: fields,
      revenue: revenue,
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Create Manual Booking - Primary Action
        SizedBox(
          width: double.infinity,
          height: 70,
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/owner/bookings/manual',
              );
              if (result == true && mounted) {
                _loadDashboardData();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Manual Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'For walk-in customers',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Manage\nBookings',
                icon: Icons.list_alt_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/owner/bookings');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Manage\nFields',
                icon: Icons.stadium_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/owner/fields');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Analytics',
                icon: Icons.bar_chart_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/owner/analytics');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Settings',
                icon: Icons.settings_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFAB47BC), Color(0xFFBA68C8)],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/owner/settings');
                },
              ),
            ),
          ],
        ),
      ],
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

    final bookings = state is OwnerBookingsLoaded
        ? state.bookings
        : <BookingEntity>[];

    return RecentBookingsSection(
      bookings: bookings,
      onViewAll: () {
        Navigator.pushNamed(context, '/owner/bookings');
      },
    );
  }
}
