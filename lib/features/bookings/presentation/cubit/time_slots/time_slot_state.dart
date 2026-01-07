import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

/// Base class for all time slot states.
sealed class TimeSlotState extends Equatable {
  const TimeSlotState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class TimeSlotInitial extends TimeSlotState {
  const TimeSlotInitial();
}

/// Loading state.
class TimeSlotLoading extends TimeSlotState {
  final String message;

  const TimeSlotLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class TimeSlotError extends TimeSlotState {
  final String message;

  const TimeSlotError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Time slots loaded successfully.
class TimeSlotsLoaded extends TimeSlotState {
  final List<TimeSlotEntity> timeSlots;
  final DateTime selectedDate;
  final String fieldId;
  final TimeSlotEntity? selectedSlot;

  const TimeSlotsLoaded({
    required this.timeSlots,
    required this.selectedDate,
    required this.fieldId,
    this.selectedSlot,
  });

  @override
  List<Object?> get props => [timeSlots, selectedDate, fieldId, selectedSlot];

  /// Check if there are available slots.
  bool get hasAvailableSlots => timeSlots.any((slot) => slot.isAvailable);

  /// Get available slots only.
  List<TimeSlotEntity> get availableSlots =>
      timeSlots.where((slot) => slot.isAvailable).toList();

  /// Group slots by period.
  Map<String, List<TimeSlotEntity>> get slotsByPeriod =>
      TimeSlotEntity.groupSlotsByPeriod(timeSlots);

  TimeSlotsLoaded copyWith({
    List<TimeSlotEntity>? timeSlots,
    DateTime? selectedDate,
    String? fieldId,
    TimeSlotEntity? selectedSlot,
  }) {
    return TimeSlotsLoaded(
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      fieldId: fieldId ?? this.fieldId,
      selectedSlot: selectedSlot ?? this.selectedSlot,
    );
  }
}
