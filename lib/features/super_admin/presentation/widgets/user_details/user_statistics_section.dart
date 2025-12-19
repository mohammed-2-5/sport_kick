import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_stats_card.dart';

/// Statistics section widget for user details page.
/// Displays booking and spending statistics for a user.
class UserStatisticsSection extends StatelessWidget {
  final UserEntity user;

  const UserStatisticsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.spacingMedium),
          BlocBuilder<SuperAdminCubit, SuperAdminState>(
            builder: (context, state) {
              if (state is AllBookingsLoaded) {
                return _buildStatsGrid(state.bookings.cast<BookingEntity>());
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<BookingEntity> allBookings) {
    final userBookings = allBookings.where((b) => b.userId == user.id).toList();

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
}
