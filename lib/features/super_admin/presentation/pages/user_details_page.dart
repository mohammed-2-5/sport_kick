import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_booking_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_empty_bookings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_stats_card.dart';

/// User Details Page
///
/// Comprehensive view of a regular user account showing:
/// - Profile information
/// - Booking history
/// - Spending statistics
/// - Actions (Deactivate/Activate)
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllBookings(),
      child: _UserDetailsView(user: user),
    );
  }
}

class _UserDetailsView extends StatefulWidget {
  final UserEntity user;

  const _UserDetailsView({required this.user});

  @override
  State<_UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<_UserDetailsView> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  void _handleStatusToggle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          currentUser.isActive ? 'Deactivate User?' : 'Activate User?',
        ),
        content: Text(
          currentUser.isActive
              ? 'This will prevent the user from logging in and making new bookings.'
              : 'This will restore the user\'s access to the platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: currentUser.isActive ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (currentUser.isActive) {
                context.read<SuperAdminCubit>().deactivateUser(currentUser.id);
              } else {
                context.read<SuperAdminCubit>().activateUser(currentUser.id);
              }

              setState(() {
                currentUser = currentUser.copyWith(
                  isActive: !currentUser.isActive,
                );
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    currentUser.isActive
                        ? 'User activated successfully'
                        : 'User deactivated successfully',
                  ),
                  backgroundColor: currentUser.isActive
                      ? Colors.green
                      : Colors.red,
                ),
              );
            },
            child: Text(currentUser.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AdminUIConstants.spacingXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(user: currentUser),
            const SizedBox(height: AdminUIConstants.spacingMedium),
            UserActionButtons(
              user: currentUser,
              onToggleStatus: _handleStatusToggle,
            ),
            const SizedBox(height: AdminUIConstants.spacingLarge),
            _buildStatisticsSection(context),
            const SizedBox(height: AdminUIConstants.spacingLarge),
            _buildBookingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),
          BlocBuilder<SuperAdminCubit, SuperAdminState>(
            builder: (context, state) {
              if (state is AllBookingsLoaded) {
                // Filter bookings for this user
                // Note: state.bookings is List<dynamic>, cast to List<BookingEntity>
                final userBookings = state.bookings
                    .cast<BookingEntity>()
                    .where((b) => b.userId == currentUser.id)
                    .toList();

                final totalBookings = userBookings.length;
                final pendingBookings = userBookings
                    .where((b) => b.status == BookingStatus.pending)
                    .length;
                final confirmedBookings = userBookings
                    .where((b) => b.status == BookingStatus.confirmed)
                    .length;
                final totalSpent = userBookings
                    .where(
                      (b) =>
                          b.status == BookingStatus.confirmed ||
                          b.status == BookingStatus.completed,
                    )
                    .fold<double>(0, (sum, b) => sum + b.totalPrice);

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: UserStatsCard(
                            label: 'Total Bookings',
                            value: totalBookings.toString(),
                            icon: Icons.event,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: UserStatsCard(
                            label: 'Pending',
                            value: pendingBookings.toString(),
                            icon: Icons.schedule,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AdminUIConstants.listItemSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: UserStatsCard(
                            label: 'Confirmed',
                            value: confirmedBookings.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: UserStatsCard(
                            label: 'Total Spent',
                            value: '${totalSpent.toStringAsFixed(0)} EGP',
                            icon: Icons.attach_money,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              if (state is SuperAdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Fallback for other states or initial load
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking History',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),
          BlocBuilder<SuperAdminCubit, SuperAdminState>(
            builder: (context, state) {
              if (state is SuperAdminLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AllBookingsLoaded) {
                final userBookings =
                    state.bookings
                        .cast<BookingEntity>()
                        .where((b) => b.userId == currentUser.id)
                        .toList()
                      ..sort((a, b) => b.date.compareTo(a.date));

                if (userBookings.isEmpty) {
                  return const UserEmptyBookingsState();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userBookings.length,
                  itemBuilder: (context, index) {
                    final booking = userBookings[index];
                    return UserBookingCard(
                      booking: booking,
                      onTap: () {
                        context.pushNamed(
                          'bookingDetails',
                          pathParameters: {'bookingId': booking.id},
                        );
                      },
                    );
                  },
                );
              }

              return const Center(child: Text('Loading bookings...'));
            },
          ),
        ],
      ),
    );
  }
}
