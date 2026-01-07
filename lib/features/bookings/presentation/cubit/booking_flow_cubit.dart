import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/find_consecutive_slot_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/group_time_slots_by_period_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/validate_slot_selection_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_flow_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Cubit managing the multi-step booking flow wizard.
///
/// Handles:
/// - Step navigation (date → time → confirm → success)
/// - Date selection and time slot loading
/// - Time slot selection
/// - Booking submission
///
/// This cubit is specifically designed for the create booking flow,
/// separate from the general [BookingCubit] for better separation of concerns.
class BookingFlowCubit extends Cubit<BookingFlowState> {
  final GetAvailableTimeSlotsUseCase _getAvailableTimeSlotsUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final GroupTimeSlotsByPeriodUseCase _groupTimeSlotsByPeriodUseCase;
  final FindConsecutiveSlotUseCase _findConsecutiveSlotUseCase;
  final ValidateSlotSelectionUseCase _validateSlotSelectionUseCase;

  BookingFlowCubit({
    required GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required GroupTimeSlotsByPeriodUseCase groupTimeSlotsByPeriodUseCase,
    required FindConsecutiveSlotUseCase findConsecutiveSlotUseCase,
    required ValidateSlotSelectionUseCase validateSlotSelectionUseCase,
  }) : _getAvailableTimeSlotsUseCase = getAvailableTimeSlotsUseCase,
       _createBookingUseCase = createBookingUseCase,
       _groupTimeSlotsByPeriodUseCase = groupTimeSlotsByPeriodUseCase,
       _findConsecutiveSlotUseCase = findConsecutiveSlotUseCase,
       _validateSlotSelectionUseCase = validateSlotSelectionUseCase,
       super(const BookingFlowInitial());

  /// Initialize the booking flow for a specific field.
  ///
  /// Sets up the initial state and loads available time slots.
  /// First available date is tomorrow (not today).
  Future<void> initializeFlow(FieldEntity field) async {
    // First available booking date is tomorrow
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final initialDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    emit(
      BookingFlowActive(
        currentStep: BookingFlowStep.selectDate,
        fieldId: field.id,
        fieldName: field.name,
        pricePerHour: field.pricePerHour,
        selectedDate: initialDate,
        isLoadingSlots: true,
        selectedDuration: 1,
      ),
    );

    await _loadTimeSlots(field.id, initialDate);
  }

  /// Select a new date and load time slots.
  Future<void> selectDate(DateTime date) async {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    // Clear previous selection and load new slots
    emit(
      currentState.copyWith(
        selectedDate: date,
        clearTimeSlot: true,
        clearSecondSlot: true,
        isLoadingSlots: true,
        clearError: true,
      ),
    );

    await _loadTimeSlots(currentState.fieldId, date);
  }

  /// Select booking duration (1 or 2 hours).
  void selectDuration(int hours) {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;
    if (hours != 1 && hours != 2) return;

    // Clear selected time slot when changing duration
    emit(
      currentState.copyWith(
        selectedDuration: hours,
        clearTimeSlot: true,
        clearSecondSlot: true,
      ),
    );
  }

  /// Load available time slots for the given date.
  Future<void> _loadTimeSlots(String fieldId, DateTime date) async {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    final result = await _getAvailableTimeSlotsUseCase(
      fieldId: fieldId,
      date: date,
    );

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isLoadingSlots: false,
            slotsError: failure.message,
            slotsByPeriod: const {},
          ),
        );
      },
      (timeSlots) {
        final slotsByPeriod = _groupTimeSlotsByPeriodUseCase(timeSlots);
        emit(
          currentState.copyWith(
            isLoadingSlots: false,
            slotsByPeriod: slotsByPeriod,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Select a time slot.
  ///
  /// For 2-hour bookings, also finds and validates the consecutive slot.
  void selectTimeSlot(TimeSlotEntity slot) {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    // For 1-hour booking, just select the slot
    if (currentState.selectedDuration == 1) {
      emit(
        currentState.copyWith(selectedTimeSlot: slot, clearSecondSlot: true),
      );
      return;
    }

    // For 2-hour booking, find the consecutive slot
    final secondSlot = _findConsecutiveSlotUseCase(
      slot: slot,
      slotsByPeriod: currentState.slotsByPeriod,
    );

    if (secondSlot == null || !secondSlot.isAvailable) {
      // Can't select this slot for 2-hour booking
      emit(
        currentState.copyWith(
          slotsError: 'Consecutive slot not available for 2-hour booking',
        ),
      );
      return;
    }

    emit(
      currentState.copyWith(
        selectedTimeSlot: slot,
        secondTimeSlot: secondSlot,
        clearError: true,
      ),
    );
  }

  /// Check if a slot can be selected for the current duration.
  bool canSelectSlot(TimeSlotEntity slot) {
    final currentState = state;
    if (currentState is! BookingFlowActive) return false;

    return _validateSlotSelectionUseCase(
      slot: slot,
      durationHours: currentState.selectedDuration,
      slotsByPeriod: currentState.slotsByPeriod,
    );
  }

  /// Select time slot if valid for current duration.
  /// This method validates and selects in one call for UI simplicity.
  void selectTimeSlotIfValid(TimeSlotEntity slot) {
    if (canSelectSlot(slot)) {
      selectTimeSlot(slot);
    }
  }

  /// Check if any slot can accommodate a 2-hour booking.
  bool get isTwoHourAvailable {
    final currentState = state;
    if (currentState is! BookingFlowActive) return false;

    final allSlots = currentState.slotsByPeriod.values
        .expand((s) => s)
        .toList();

    for (final slot in allSlots) {
      if (!slot.isAvailable) continue;

      final secondSlot = _findConsecutiveSlotUseCase(
        slot: slot,
        slotsByPeriod: currentState.slotsByPeriod,
      );
      if (secondSlot != null && secondSlot.isAvailable) {
        return true;
      }
    }
    return false;
  }

  /// Navigate to the next step.
  void nextStep() {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;
    if (!currentState.canProceed) return;

    final nextStepIndex = currentState.currentStep.index + 1;
    if (nextStepIndex > BookingFlowStep.confirm.index) return;

    final nextStep = BookingFlowStep.values[nextStepIndex];
    emit(currentState.copyWith(currentStep: nextStep));
  }

  /// Navigate to the previous step.
  void previousStep() {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    final prevStepIndex = currentState.currentStep.index - 1;
    if (prevStepIndex < 0) return;

    final prevStep = BookingFlowStep.values[prevStepIndex];
    emit(currentState.copyWith(currentStep: prevStep));
  }

  /// Jump to a specific step (for step indicator taps).
  void goToStep(BookingFlowStep step) {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    // Can only go back or to current step
    if (step.index > currentState.currentStep.index) return;

    emit(currentState.copyWith(currentStep: step));
  }

  /// Submit the booking.
  Future<void> submitBooking({String? notes}) async {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;
    if (currentState.selectedTimeSlot == null) return;

    // Calculate end time based on duration
    final endTime =
        currentState.endTime ?? currentState.selectedTimeSlot!.endTime;

    // Use actual booking date (considers next day for cross-midnight slots)
    final bookingDate = currentState.actualBookingDate;

    emit(
      BookingFlowSubmitting(
        fieldId: currentState.fieldId,
        selectedDate: bookingDate,
        selectedTimeSlot: currentState.selectedTimeSlot!,
        durationHours: currentState.selectedDuration,
        endTime: endTime,
      ),
    );

    final result = await _createBookingUseCase(
      fieldId: currentState.fieldId,
      date: bookingDate,
      startTime: currentState.selectedTimeSlot!.startTime,
      endTime: endTime,
      totalPrice: currentState.totalPrice,
      notes: notes,
      durationHours: currentState.selectedDuration,
    );

    result.fold(
      (failure) {
        emit(
          BookingFlowError(
            message: failure.message,
            previousState: currentState,
          ),
        );
      },
      (booking) {
        emit(BookingFlowSuccess(booking));
      },
    );
  }

  /// Retry after an error.
  void retryFromError() {
    final currentState = state;
    if (currentState is BookingFlowError) {
      emit(currentState.previousState);
    }
  }

  /// Reset the flow to initial state.
  void reset() {
    emit(const BookingFlowInitial());
  }
}
