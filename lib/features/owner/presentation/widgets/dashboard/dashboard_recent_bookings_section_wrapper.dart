import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/recent_bookings_section.dart';

/// Wrapper widget that handles loading state and data extraction for recent bookings.
class DashboardRecentBookingsSectionWrapper extends StatelessWidget {
  final OwnerState state;

  const DashboardRecentBookingsSectionWrapper({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is OwnerLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bookings = state is OwnerDataLoaded
        ? (state as OwnerDataLoaded).bookings
        : (state is OwnerBookingsLoaded
              ? (state as OwnerBookingsLoaded).bookings
              : <BookingEntity>[]);

    return RecentBookingsSection(
      bookings: bookings,
      onViewAll: () {
        context.pushNamed('ownerBookings');
      },
    );
  }
}
