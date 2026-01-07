import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_loading_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/my_bookings_tab_view.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring_tab_view.dart';

class MyBookingsContent extends StatelessWidget {
  final BookingManagementState state;
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

    if (bookingState is BookingManagementLoading) {
      return const MyBookingsLoadingState();
    }

    if (bookingState is BookingsEmpty) {
      return MyBookingsEmptyState(
        message: bookingState.message ?? context.l10n.noBookingsYet,
        onBrowseFields: onBrowseFields,
      );
    }

    if (bookingState is BookingsLoaded) {
      return TabBarView(
        controller: tabController,
        children: [
          MyBookingsTabView(
            bookings: bookingState.upcomingBookings,
            emptyMessage: context.l10n.noUpcomingBookings,
            onRefresh: onRefresh,
            isHistory: false,
            onAction: onBrowseFields,
          ),
          MyBookingsTabView(
            bookings: bookingState.historyBookings,
            emptyMessage: context.l10n.noBookingHistory,
            onRefresh: onRefresh,
            isHistory: true,
            onAction: onBrowseFields,
          ),
          RecurringTabView(onRefresh: onRefresh, onCreateNew: onBrowseFields),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
