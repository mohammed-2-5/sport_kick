import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
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

  BookingFlowCubit({
    required GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase,
    required CreateBookingUseCase createBookingUseCase,
  }) : _getAvailableTimeSlotsUseCase = getAvailableTimeSlotsUseCase,
       _createBookingUseCase = createBookingUseCase,
       super(const BookingFlowInitial());

  /// Initialize the booking flow for a specific field.
  ///
  /// Sets up the initial state and loads available time slots
  /// for today's date.
  Future<void> initializeFlow(FieldEntity field) async {
    final today = DateTime.now();

    emit(
      BookingFlowActive(
        currentStep: BookingFlowStep.selectDate,
        fieldId: field.id,
        fieldName: field.name,
        pricePerHour: field.pricePerHour,
        selectedDate: today,
        isLoadingSlots: true,
      ),
    );

    await _loadTimeSlots(field.id, today);
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
        isLoadingSlots: true,
        clearError: true,
      ),
    );

    await _loadTimeSlots(currentState.fieldId, date);
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
        final slotsByPeriod = _groupSlotsByPeriod(timeSlots);
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

  /// Group time slots by period (Morning, Afternoon, Evening).
  Map<String, List<TimeSlotEntity>> _groupSlotsByPeriod(
    List<TimeSlotEntity> slots,
  ) {
    final Map<String, List<TimeSlotEntity>> grouped = {
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
    };

    for (final slot in slots) {
      final hour = int.tryParse(slot.startTime.split(':')[0]) ?? 0;
      if (hour < 12) {
        grouped['Morning']!.add(slot);
      } else if (hour < 17) {
        grouped['Afternoon']!.add(slot);
      } else {
        grouped['Evening']!.add(slot);
      }
    }

    // Remove empty periods
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  /// Select a time slot.
  void selectTimeSlot(TimeSlotEntity slot) {
    final currentState = state;
    if (currentState is! BookingFlowActive) return;

    emit(currentState.copyWith(selectedTimeSlot: slot));
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

    emit(
      BookingFlowSubmitting(
        fieldId: currentState.fieldId,
        selectedDate: currentState.selectedDate,
        selectedTimeSlot: currentState.selectedTimeSlot!,
      ),
    );

    final result = await _createBookingUseCase(
      fieldId: currentState.fieldId,
      date: currentState.selectedDate,
      startTime: currentState.selectedTimeSlot!.startTime,
      endTime: currentState.selectedTimeSlot!.endTime,
      totalPrice: currentState.selectedTimeSlot!.price,
      notes: notes,
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
