import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/stat_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/quick_action_card.dart';

import '../../../bookings/domain/entities/booking_entity.dart';

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
    _loadData();
  }

  void _loadData() {
    context.read<BookingCubit>().loadOwnerBookings();
    context.read<FieldsCubit>().loadAllFields();
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
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              _buildWelcomeHeader(),

              const SizedBox(height: 24),

              // Statistics Cards
              _buildStatsSection(),

              const SizedBox(height: 32),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: 32),

              // Recent Bookings Section
              _buildRecentBookingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your football fields',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, bookingsState) {
        return BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, fieldsState) {
            int totalBookings = 0;
            int pendingBookings = 0;
            int totalFields = 0;
            double totalRevenue = 0;

            if (bookingsState is BookingsLoaded) {
              totalBookings = bookingsState.bookings.length;
              pendingBookings = bookingsState.bookings
                  .where((b) => b.status.toString().contains('pending'))
                  .length;
              totalRevenue = bookingsState.bookings
                  .where((b) => b.status.toString().contains('confirmed'))
                  .fold(0, (sum, b) => sum + b.totalPrice);
            }

            if (fieldsState is FieldsLoaded) {
              totalFields = fieldsState.fields.length;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Bookings',
                        value: totalBookings.toString(),
                        icon: Icons.calendar_month_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Pending',
                        value: pendingBookings.toString(),
                        icon: Icons.pending_actions_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'My Fields',
                        value: totalFields.toString(),
                        icon: Icons.sports_soccer_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        title: 'Revenue',
                        value: '\$${totalRevenue.toStringAsFixed(0)}',
                        icon: Icons.attach_money_rounded,
                        gradient: AppGradients.primary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
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
              // Refresh bookings if manual booking was created
              if (result == true && context.mounted) {
                context.read<BookingCubit>().loadOwnerBookings();
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

  Widget _buildRecentBookingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/owner/bookings');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is BookingsLoaded) {
              final recentBookings = state.bookings.take(5).toList();

              if (recentBookings.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentBookings.length,
                itemBuilder: (context, index) {
                  final booking = recentBookings[index];
                  return _buildBookingItem(booking);
                },
              );
            }

            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  Widget _buildBookingItem(BookingEntity  booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.fieldName ?? 'Unknown Field',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: _getStatusGradient(booking.status.toString()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
    booking.status
        .toString()
        .split('.')
        .last
        .toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getStatusGradient(String status) {
    if (status.contains('confirmed')) {
      return AppGradients.success;
    } else if (status.contains('pending')) {
      return AppGradients.warning;
    } else if (status.contains('canceled')) {
      return AppGradients.error;
    } else {
      return const LinearGradient(
        colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
      );
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No bookings yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bookings will appear here once customers start booking your fields',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
