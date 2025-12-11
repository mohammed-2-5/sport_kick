import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Enum representing the current step in the booking flow.
enum BookingFlowStep { selectDate, selectTime, confirm, success }

/// Extension to provide step metadata.
extension BookingFlowStepX on BookingFlowStep {
  int get index {
    switch (this) {
      case BookingFlowStep.selectDate:
        return 0;
      case BookingFlowStep.selectTime:
        return 1;
      case BookingFlowStep.confirm:
        return 2;
      case BookingFlowStep.success:
        return 3;
    }
  }

  String get title {
    switch (this) {
      case BookingFlowStep.selectDate:
        return 'Select Date';
      case BookingFlowStep.selectTime:
        return 'Choose Time';
      case BookingFlowStep.confirm:
        return 'Confirm';
      case BookingFlowStep.success:
        return 'Booked!';
    }
  }

  bool get isCompleted => index < BookingFlowStep.success.index;
}

/// Base state for the booking flow.
sealed class BookingFlowState extends Equatable {
  const BookingFlowState();

  @override
  List<Object?> get props => [];
}

/// Initial state before flow starts.
class BookingFlowInitial extends BookingFlowState {
  const BookingFlowInitial();
}

/// Active booking flow state.
///
/// Contains all data needed for the multi-step booking wizard.
class BookingFlowActive extends BookingFlowState {
  final BookingFlowStep currentStep;
  final String fieldId;
  final String fieldName;
  final double pricePerHour;
  final DateTime selectedDate;
  final TimeSlotEntity? selectedTimeSlot;
  final Map<String, List<TimeSlotEntity>> slotsByPeriod;
  final bool isLoadingSlots;
  final String? slotsError;

  const BookingFlowActive({
    required this.currentStep,
    required this.fieldId,
    required this.fieldName,
    required this.pricePerHour,
    required this.selectedDate,
    this.selectedTimeSlot,
    this.slotsByPeriod = const {},
    this.isLoadingSlots = false,
    this.slotsError,
  });

  /// Check if user can proceed to next step.
  bool get canProceed {
    switch (currentStep) {
      case BookingFlowStep.selectDate:
        return true; // Date is always selected
      case BookingFlowStep.selectTime:
        return selectedTimeSlot != null;
      case BookingFlowStep.confirm:
        return selectedTimeSlot != null;
      case BookingFlowStep.success:
        return false;
    }
  }

  /// Check if there are available slots.
  bool get hasAvailableSlots {
    return slotsByPeriod.values.any((slots) => slots.any((s) => s.isAvailable));
  }

  /// Calculate the progress percentage (0.0 - 1.0).
  double get progress => (currentStep.index + 1) / 3;

  BookingFlowActive copyWith({
    BookingFlowStep? currentStep,
    String? fieldId,
    String? fieldName,
    double? pricePerHour,
    DateTime? selectedDate,
    TimeSlotEntity? selectedTimeSlot,
    Map<String, List<TimeSlotEntity>>? slotsByPeriod,
    bool? isLoadingSlots,
    String? slotsError,
    bool clearTimeSlot = false,
    bool clearError = false,
  }) {
    return BookingFlowActive(
      currentStep: currentStep ?? this.currentStep,
      fieldId: fieldId ?? this.fieldId,
      fieldName: fieldName ?? this.fieldName,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: clearTimeSlot
          ? null
          : (selectedTimeSlot ?? this.selectedTimeSlot),
      slotsByPeriod: slotsByPeriod ?? this.slotsByPeriod,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      slotsError: clearError ? null : (slotsError ?? this.slotsError),
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    fieldId,
    fieldName,
    pricePerHour,
    selectedDate,
    selectedTimeSlot,
    slotsByPeriod,
    isLoadingSlots,
    slotsError,
  ];
}

/// Booking is being submitted.
class BookingFlowSubmitting extends BookingFlowState {
  final String fieldId;
  final DateTime selectedDate;
  final TimeSlotEntity selectedTimeSlot;

  const BookingFlowSubmitting({
    required this.fieldId,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  List<Object?> get props => [fieldId, selectedDate, selectedTimeSlot];
}

/// Booking completed successfully.
class BookingFlowSuccess extends BookingFlowState {
  final BookingEntity booking;

  const BookingFlowSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Booking failed with error.
class BookingFlowError extends BookingFlowState {
  final String message;
  final BookingFlowActive previousState;

  const BookingFlowError({required this.message, required this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}
