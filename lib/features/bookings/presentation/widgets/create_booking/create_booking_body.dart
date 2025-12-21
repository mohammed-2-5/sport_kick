import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/create_booking_content.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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
          onDateSelected: (date) => cubit.changeSelectedDate(
            date,
            loadingMessage: context.l10n.loadingAvailableTimeSlots,
          ),
          onTimeSlotSelected: cubit.selectTimeSlot,
          onConfirm: () => cubit.createBookingFromSelection(
            loadingMessage: context.l10n.creatingBooking2,
          ),
        );
      },
    );
  }
}
