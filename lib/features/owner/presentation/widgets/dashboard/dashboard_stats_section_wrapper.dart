import 'package:flutter/material.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/dashboard/dashboard_stats_section.dart';

/// Wrapper widget that handles loading state and data extraction for dashboard stats.
class DashboardStatsSectionWrapper extends StatelessWidget {
  final OwnerState state;

  const DashboardStatsSectionWrapper({super.key, required this.state});

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

    // Extract data from OwnerDataLoaded state
    final bookings = state is OwnerDataLoaded
        ? (state as OwnerDataLoaded).bookings
        : (state is OwnerBookingsLoaded
              ? (state as OwnerBookingsLoaded).bookings
              : <BookingEntity>[]);
    final fields = state is OwnerDataLoaded
        ? (state as OwnerDataLoaded).fields
        : (state is OwnerFieldsLoaded
              ? (state as OwnerFieldsLoaded).fields
              : <FieldEntity>[]);
    final revenue = state is OwnerDataLoaded
        ? ((state as OwnerDataLoaded).revenue?.totalRevenue ?? 0.0)
        : (state is OwnerRevenueLoaded
              ? (state as OwnerRevenueLoaded).revenue.totalRevenue
              : 0.0);

    return DashboardStatsSection(
      bookings: bookings,
      fields: fields,
      revenue: revenue,
    );
  }
}
