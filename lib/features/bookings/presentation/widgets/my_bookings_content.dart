import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_loading_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings_tab_view.dart';

class MyBookingsContent extends StatelessWidget {
  final BookingState state;
  final TabController tabController;
  final Future<void> Function() onRefresh;
  final VoidCallback onBrowseFields;

  const MyBookingsContent({
    required this.state,
    required this.tabController,
    required this.onRefresh,
    required this.onBrowseFields,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bookingState = state;

    if (bookingState is BookingLoading) {
      return const MyBookingsLoadingState();
    }

    if (bookingState is BookingsEmpty) {
      return MyBookingsEmptyState(
        message: bookingState.message ?? BookingConstants.noBookingsMessage,
        onBrowseFields: onBrowseFields,
      );
    }

    if (bookingState is BookingsLoaded) {
      return TabBarView(
        controller: tabController,
        children: [
          MyBookingsTabView(
            bookings: bookingState.upcomingBookings,
            emptyMessage: BookingConstants.noUpcomingMessage,
            onRefresh: onRefresh,
            isHistory: false,
          ),
          MyBookingsTabView(
            bookings: bookingState.historyBookings,
            emptyMessage: BookingConstants.noHistoryMessage,
            onRefresh: onRefresh,
            isHistory: true,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
