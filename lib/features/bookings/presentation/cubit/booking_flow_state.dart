import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

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

  String title(AppLocalizations l10n) {
    switch (this) {
      case BookingFlowStep.selectDate:
        return l10n.selectDate;
      case BookingFlowStep.selectTime:
        return l10n.chooseTime;
      case BookingFlowStep.confirm:
        return l10n.confirm;
      case BookingFlowStep.success:
        return l10n.success;
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

  /// Selected duration in hours (1 or 2)
  final int selectedDuration;

  /// Second time slot for 2-hour bookings (auto-calculated)
  final TimeSlotEntity? secondTimeSlot;

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
    this.selectedDuration = 1,
    this.secondTimeSlot,
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

  /// Get total price based on duration
  double get totalPrice => pricePerHour * selectedDuration;

  /// Get the end time for the booking (considers 2-hour bookings)
  String? get endTime {
    if (selectedTimeSlot == null) return null;
    if (selectedDuration == 2 && secondTimeSlot != null) {
      return secondTimeSlot!.endTime;
    }
    return selectedTimeSlot!.endTime;
  }

  /// Get the formatted time range for the booking
  String get formattedTimeRange {
    if (selectedTimeSlot == null) return '';
    final suffix = selectedTimeSlot!.isNextDay ? ' (+1)' : '';
    if (selectedDuration == 2 && secondTimeSlot != null) {
      return '${selectedTimeSlot!.startTime} - ${secondTimeSlot!.endTime}$suffix';
    }
    return selectedTimeSlot!.formattedTime;
  }

  /// Check if the selected duration is valid for the selected slot
  bool get isDurationValid {
    if (selectedDuration == 1) return true;
    // For 2-hour bookings, we need a valid second slot
    return secondTimeSlot != null && secondTimeSlot!.isAvailable;
  }

  /// Get the actual booking date (considering next day slots)
  DateTime get actualBookingDate {
    if (selectedTimeSlot?.isNextDay ?? false) {
      return selectedDate.add(const Duration(days: 1));
    }
    return selectedDate;
  }

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
    int? selectedDuration,
    TimeSlotEntity? secondTimeSlot,
    bool clearTimeSlot = false,
    bool clearError = false,
    bool clearSecondSlot = false,
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
      selectedDuration: selectedDuration ?? this.selectedDuration,
      secondTimeSlot: clearSecondSlot
          ? null
          : (secondTimeSlot ?? this.secondTimeSlot),
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
    selectedDuration,
    secondTimeSlot,
  ];
}

/// Booking is being submitted.
class BookingFlowSubmitting extends BookingFlowState {
  final String fieldId;
  final DateTime selectedDate;
  final TimeSlotEntity selectedTimeSlot;
  final int durationHours;
  final String endTime;

  const BookingFlowSubmitting({
    required this.fieldId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.durationHours,
    required this.endTime,
  });

  @override
  List<Object?> get props => [
    fieldId,
    selectedDate,
    selectedTimeSlot,
    durationHours,
    endTime,
  ];
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
