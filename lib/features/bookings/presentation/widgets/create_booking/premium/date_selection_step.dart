import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_date_selector.dart';

/// Date selection step content for booking flow.
class DateSelectionStep extends StatelessWidget {
  final BookingFlowActive state;

  const DateSelectionStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingFlowCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          PremiumDateSelector(
            selectedDate: state.selectedDate,
            onDateSelected: cubit.selectDate,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
