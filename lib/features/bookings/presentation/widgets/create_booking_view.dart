import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking_app_bar.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking_content.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Create Booking View - handles the main booking creation UI.
///
/// Displays:
/// - Date selection
/// - Available time slots
/// - Booking confirmation
class CreateBookingView extends StatelessWidget {
  final FieldEntity field;

  const CreateBookingView({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingError) {
          ErrorHandler.showErrorSnackbar(context, state.message);
        } else if (state is BookingCreated) {
          ErrorHandler.showSuccessSnackbar(
            context,
            BookingConstants.bookingConfirmedMessage,
          );
          // Navigate to My Bookings to show the new booking
          context.goNamed('myBookings');
        }
      },
      builder: (context, state) {
        final bookingCubit = context.read<BookingCubit>();
        final selectedDate = bookingCubit.selectedDate;
        final selectedTimeSlot = bookingCubit.selectedTimeSlot;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CreateBookingAppBar(),
          body: CreateBookingContent(
            field: field,
            state: state,
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot,
            onDateSelected: bookingCubit.changeSelectedDate,
            onTimeSlotSelected: bookingCubit.selectTimeSlot,
            onConfirm: bookingCubit.createBookingFromSelection,
          ),
        );
      },
    );
  }
}
