import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/create_booking_content.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Body content for create booking view.
///
/// Renders booking content based on cubit state.
class CreateBookingBody extends StatelessWidget {
  final FieldEntity field;

  const CreateBookingBody({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return CreateBookingContent(
          field: field,
          state: state,
          selectedDate: cubit.selectedDate,
          selectedTimeSlot: cubit.selectedTimeSlot,
          onDateSelected: cubit.changeSelectedDate,
          onTimeSlotSelected: cubit.selectTimeSlot,
          onConfirm: cubit.createBookingFromSelection,
        );
      },
    );
  }
}
