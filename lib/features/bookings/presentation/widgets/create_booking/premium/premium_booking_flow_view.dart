import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/error_handler.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_step_indicator.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/booking_success_overlay.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_booking_confirmation.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_date_selector.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/premium_time_selection_step.dart';

import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/l10n/app_localizations.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

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
          return _buildSubmittingState(context);
        }

        // Initial or loading
        return _buildLoadingState();
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
            _BottomActionBar(
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
        return _DateSelectionStep(state: state);

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

  Widget _buildSubmittingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.creatingBooking,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.pleaseWaitMoment,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        );
      },
    );
  }
}

/// Date selection step content.
class _DateSelectionStep extends StatelessWidget {
  final BookingFlowActive state;

  const _DateSelectionStep({required this.state});

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

/// Bottom action bar with next/proceed button.
class _BottomActionBar extends StatelessWidget {
  final BookingFlowActive state;
  final VoidCallback onNext;

  const _BottomActionBar({required this.state, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price preview (if slot selected)
            if (state.selectedTimeSlot != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.totalWithHours(state.selectedDuration),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      LocaleFormatters.formatPrice(
                        context,
                        amount: state.totalPrice,
                        currency:
                            state.selectedTimeSlot?.currency ??
                            context.l10n.currencyEgp,
                        decimalDigits: 0,
                      ),
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: state.selectedTimeSlot != null ? 1 : 2,
              child: PremiumButton(
                label: _getButtonLabel(l10n),
                onPressed: state.canProceed ? onNext : null,
                icon: Icons.arrow_forward,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonLabel(AppLocalizations l10n) {
    switch (state.currentStep) {
      case BookingFlowStep.selectDate:
        return l10n.continueLabel;
      case BookingFlowStep.selectTime:
        if (!state.canProceed) {
          return l10n.selectTimeSlotPrompt;
        }
        return l10n.reviewBooking;
      default:
        return l10n.continueLabel;
    }
  }
}
