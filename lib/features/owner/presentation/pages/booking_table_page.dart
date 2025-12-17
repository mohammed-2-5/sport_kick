import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_view.dart';

/// Booking Table Page - Weekly schedule view for field bookings.
///
/// Shows an Excel-style grid with:
/// - 7 days as columns (Sat-Fri)
/// - Working hours as rows
/// - Bookings displayed in their time slots
/// - Week navigation
/// - Field selector for owners with multiple fields
class BookingTablePage extends StatelessWidget {
  const BookingTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user ID from auth cubit
    final authState = context.read<AuthCubit>().state;
    final ownerId = authState is Authenticated ? authState.user.id : '';

    return BlocProvider(
      create: (_) => BookingTableCubit(
        fieldRepository: sl<FieldRepository>(),
        bookingRepository: sl<BookingRepository>(),
        businessHoursRepository: sl<BusinessHoursRepository>(),
        ownerId: ownerId,
      )..initialize(),
      child: const BookingTableView(),
    );
  }
}
