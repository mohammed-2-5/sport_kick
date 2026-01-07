import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_bottom_action_bar.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_flow_states.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_step_indicator.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_success_overlay.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/date_selection_step.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_booking_confirmation.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_time_selection_step.dart';

import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Premium booking flow view with wizard-style navigation.
///
/// Orchestrates the multi-step booking process:
/// 1. Select Date
/// 2. Choose Time Slot
/// 3. Confirm Booking
/// 4. Success
class PremiumBookingFlowView extends StatelessWidget {
  final FieldEntity field;

  const PremiumBookingFlowView({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listener: _handleStateChange,
      builder: (context, state) {
        // Success state - show overlay
        if (state is BookingFlowSuccess) {
          return BookingSuccessOverlay(
            booking: state.booking,
            field: field,
            onViewBookings: () => context.pushNamed('myBookings'),
            onViewInvoice: () => context.pushNamed(
              'bookingInvoice',
              extra: {'booking': state.booking, 'field': field},
            ),
            onDone: () => context.go('/home'),
          );
        }

        // Error state - show snackbar and return to previous state
        if (state is BookingFlowError) {
          return _buildFlowContent(context, state.previousState);
        }

        // Active flow state
        if (state is BookingFlowActive) {
          return _buildFlowContent(context, state);
        }

        // Submitting state
        if (state is BookingFlowSubmitting) {
          return const BookingSubmittingState();
        }

        // Initial or loading
        return const BookingLoadingState();
      },
    );
  }

  void _handleStateChange(BuildContext context, BookingFlowState state) {
    if (state is BookingFlowError) {
      ErrorHandler.showErrorSnackbar(context, state.message);
    }
  }

  Widget _buildFlowContent(BuildContext context, BookingFlowActive state) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          PremiumCurvedHeader(
            title: _getHeaderTitle(context, state.currentStep),
            subtitle: field.name,
            showBackButton: true,
            onBackPressed: () => _handleBack(context, state),
            height: 160,
          ),

          // Step Indicator
          BookingStepIndicator(
            currentStep: state.currentStep,
            onStepTapped: (step) =>
                context.read<BookingFlowCubit>().goToStep(step),
          ),

          // Content based on current step
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStepContent(context, state),
            ),
          ),

          // Bottom Action Bar (for steps 1 & 2)
          if (state.currentStep != BookingFlowStep.confirm)
            BookingBottomActionBar(
              state: state,
              onNext: () => context.read<BookingFlowCubit>().nextStep(),
            ),
        ],
      ),
    );
  }

  String _getHeaderTitle(BuildContext context, BookingFlowStep step) {
    final l10n = context.l10n;
    switch (step) {
      case BookingFlowStep.selectDate:
        return l10n.bookFieldTitle;
      case BookingFlowStep.selectTime:
        return l10n.chooseTime;
      case BookingFlowStep.confirm:
        return l10n.confirmBooking;
      case BookingFlowStep.success:
        return l10n.success;
    }
  }

  void _handleBack(BuildContext context, BookingFlowActive state) {
    if (state.currentStep == BookingFlowStep.selectDate) {
      context.pop();
    } else {
      context.read<BookingFlowCubit>().previousStep();
    }
  }

  Widget _buildStepContent(BuildContext context, BookingFlowActive state) {
    switch (state.currentStep) {
      case BookingFlowStep.selectDate:
        return DateSelectionStep(state: state);

      case BookingFlowStep.selectTime:
        return PremiumTimeSelectionStep(
          state: state,
          pricePerHour: state.pricePerHour,
        );

      case BookingFlowStep.confirm:
        return PremiumBookingConfirmation(
          fieldName: state.fieldName,
          selectedDate: state.selectedDate,
          selectedSlot: state.selectedTimeSlot!,
          totalPrice: state.totalPrice,
          durationHours: state.selectedDuration,
          onConfirm: () => context.read<BookingFlowCubit>().submitBooking(),
          onBack: () => context.read<BookingFlowCubit>().previousStep(),
          isSubmitting: false,
        );

      case BookingFlowStep.success:
        return const SizedBox.shrink(); // Handled by overlay
    }
  }
}
