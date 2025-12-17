import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/bookings/owner_booking_detail_view.dart';

/// Owner booking detail page.
///
/// Shows comprehensive booking information including:
/// - Booking status and timeline
/// - Customer information
/// - Payment status and proof
/// - Action buttons for verification
///
/// Updated: 2025-12-13
class OwnerBookingDetailPage extends StatelessWidget {
  final BookingEntity booking;

  const OwnerBookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerBookingsCubit>(),
      child: OwnerBookingDetailView(booking: booking),
    );
  }
}
