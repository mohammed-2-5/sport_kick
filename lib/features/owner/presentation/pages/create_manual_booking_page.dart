import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/create_manual_booking_view.dart';

/// Create Manual Booking Page
///
/// 2-step flow for creating manual bookings (admin for walk-in customers):
/// - Step 1: Select field, date, time slot, and price
/// - Step 2: Enter customer information (name, phone, email, notes)
class CreateManualBookingPage extends StatelessWidget {
  const CreateManualBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(create: (_) => sl<BookingCubit>()),
      ],
      child: const CreateManualBookingView(),
    );
  }
}
