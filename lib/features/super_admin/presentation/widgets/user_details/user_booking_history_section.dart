import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_booking_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_empty_bookings_state.dart';

/// Booking history section widget for user details page.
/// Displays a list of user's bookings sorted by date.
class UserBookingHistorySection extends StatelessWidget {
  final UserEntity user;

  const UserBookingHistorySection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
                return _buildBookingsList(
                  context,
                  state.bookings.cast<BookingEntity>(),
                );
              }

              return const Center(child: Text('Loading bookings...'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<BookingEntity> allBookings,
  ) {
    final userBookings = allBookings.where((b) => b.userId == user.id).toList()
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
}
