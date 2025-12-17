import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// States for create recurring booking flow.
sealed class CreateRecurringState extends Equatable {
  const CreateRecurringState();

  @override
  List<Object?> get props => [];
}

/// Initial/editing state with form data.
final class CreateRecurringEditing extends CreateRecurringState {
  final FieldEntity field;
  final int? selectedDayOfWeek;
  final String? selectedTime;
  final int durationHours;
  final List<ReservedSlot> reservedSlots;
  final bool isLoadingSlots;
  final String? errorMessage;

  const CreateRecurringEditing({
    required this.field,
    this.selectedDayOfWeek,
    this.selectedTime,
    this.durationHours = 1,
    this.reservedSlots = const [],
    this.isLoadingSlots = false,
    this.errorMessage,
  });

  /// Calculate price per booking.
  double get pricePerBooking => field.pricePerHour * durationHours;

  /// Calculate end time based on start time and duration.
  String? get endTime {
    if (selectedTime == null) return null;
    final parts = selectedTime!.split(':');
    final startHour = int.parse(parts[0]);
    final endHour = startHour + durationHours;
    if (endHour > 23) return null;
    return '${endHour.toString().padLeft(2, '0')}:00';
  }

  /// Check if the form is valid.
  bool get isValid =>
      selectedDayOfWeek != null && selectedTime != null && endTime != null;

  /// Check if a specific slot is reserved.
  bool isSlotReserved(int dayOfWeek, String time) {
    return reservedSlots.any(
      (slot) =>
          slot.dayOfWeek == dayOfWeek &&
          _isTimeInRange(time, slot.startTime, slot.endTime),
    );
  }

  bool _isTimeInRange(String time, String start, String end) {
    final timeHour = int.parse(time.split(':')[0]);
    final startHour = int.parse(start.split(':')[0]);
    final endHour = int.parse(end.split(':')[0]);
    return timeHour >= startHour && timeHour < endHour;
  }

  /// Get day name.
  String get selectedDayName {
    if (selectedDayOfWeek == null) return '';
    const days = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];
    return days[selectedDayOfWeek!];
  }

  CreateRecurringEditing copyWith({
    FieldEntity? field,
    int? selectedDayOfWeek,
    String? selectedTime,
    int? durationHours,
    List<ReservedSlot>? reservedSlots,
    bool? isLoadingSlots,
    String? errorMessage,
    bool clearDayOfWeek = false,
    bool clearTime = false,
    bool clearError = false,
  }) {
    return CreateRecurringEditing(
      field: field ?? this.field,
      selectedDayOfWeek: clearDayOfWeek
          ? null
          : (selectedDayOfWeek ?? this.selectedDayOfWeek),
      selectedTime: clearTime ? null : (selectedTime ?? this.selectedTime),
      durationHours: durationHours ?? this.durationHours,
      reservedSlots: reservedSlots ?? this.reservedSlots,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    field,
    selectedDayOfWeek,
    selectedTime,
    durationHours,
    reservedSlots,
    isLoadingSlots,
    errorMessage,
  ];
}

/// Submitting state.
final class CreateRecurringSubmitting extends CreateRecurringState {
  const CreateRecurringSubmitting();
}

/// Success state.
final class CreateRecurringSuccess extends CreateRecurringState {
  final String recurringBookingId;

  const CreateRecurringSuccess(this.recurringBookingId);

  @override
  List<Object?> get props => [recurringBookingId];
}

/// Error state.
final class CreateRecurringError extends CreateRecurringState {
  final String message;
  final FieldEntity field;

  const CreateRecurringError({required this.message, required this.field});

  @override
  List<Object?> get props => [message, field];
}
