import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/booking_duration_selector.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/date_summary_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_time_slot_grid.dart';

/// Time selection step content with duration selector.
///
/// Displays date summary, duration options, and available time slots.
class PremiumTimeSelectionStep extends StatelessWidget {
  /// Current booking flow state.
  final BookingFlowActive state;

  /// Price per hour for the field.
  final double pricePerHour;

  const PremiumTimeSelectionStep({
    super.key,
    required this.state,
    required this.pricePerHour,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingFlowCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateSummaryCard(
            selectedDate: state.selectedDate,
            onChangePressed: cubit.previousStep,
          ),
          const SizedBox(height: 20),
          BookingDurationSelector(
            selectedDuration: state.selectedDuration,
            pricePerHour: pricePerHour,
            onDurationSelected: cubit.selectDuration,
            isTwoHourAvailable: cubit.isTwoHourAvailable,
          ),
          const SizedBox(height: 24),
          PremiumTimeSlotGrid(
            slotsByPeriod: state.slotsByPeriod,
            selectedSlot: state.selectedTimeSlot,
            secondSlot: state.secondTimeSlot,
            selectedDuration: state.selectedDuration,
            canSelectSlot: cubit.canSelectSlot,
            onSlotSelected: cubit.selectTimeSlotIfValid,
            isLoading: state.isLoadingSlots,
            errorMessage: state.slotsError,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
