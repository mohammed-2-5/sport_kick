import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/time_slots/time_slot_state.dart';

/// Cubit for managing time slot selection state.
///
/// Handles time slot-related operations:
/// - Loading available time slots for a field on a specific date
/// - Managing selected date
/// - Managing selected time slot
/// - Starting booking flow for a field
class TimeSlotCubit extends Cubit<TimeSlotState> {
  final GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase;

  DateTime _selectedDate = DateTime.now();
  TimeSlotEntity? _selectedTimeSlot;
  String? _currentFieldId;

  TimeSlotCubit({required this.getAvailableTimeSlotsUseCase})
    : super(const TimeSlotInitial());

  DateTime get selectedDate => _selectedDate;
  TimeSlotEntity? get selectedTimeSlot => _selectedTimeSlot;
  String? get currentFieldId => _currentFieldId;

  /// Initialize booking flow for a given field.
  ///
  /// Stores the field, sets the initial date, and triggers the initial
  /// time-slot load. Keeps UI free of orchestration logic.
  Future<void> startBookingFlow(
    String fieldId, {
    DateTime? initialDate,
    required String loadingMessage,
  }) async {
    _selectedDate = initialDate ?? DateTime.now();
    _currentFieldId = fieldId;
    await loadAvailableTimeSlots(
      fieldId: fieldId,
      date: _selectedDate,
      loadingMessage: loadingMessage,
    );
  }

  /// Change selected date and reload slots for the current field.
  Future<void> changeSelectedDate(
    DateTime date, {
    required String loadingMessage,
  }) async {
    _selectedDate = date;
    if (_currentFieldId == null) {
      emit(const TimeSlotError(BookingConstants.selectDateFirstMessage));
      return;
    }
    await loadAvailableTimeSlots(
      fieldId: _currentFieldId!,
      date: date,
      loadingMessage: loadingMessage,
    );
  }

  /// Load available time slots for a field on a specific date.
  Future<void> loadAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
    required String loadingMessage,
  }) async {
    _selectedDate = date;
    _currentFieldId = fieldId;
    _selectedTimeSlot = null;
    emit(TimeSlotLoading(message: loadingMessage));

    final result = await getAvailableTimeSlotsUseCase(
      fieldId: fieldId,
      date: date,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ ERROR [TimeSlotCubit.loadAvailableTimeSlots]: ${failure.message}',
        );
        emit(TimeSlotError(failure.message));
      },
      (timeSlots) {
        if (timeSlots.isEmpty) {
          emit(const TimeSlotError('No time slots available for this date'));
        } else {
          emit(
            TimeSlotsLoaded(
              timeSlots: timeSlots,
              selectedDate: date,
              fieldId: fieldId,
              selectedSlot: _selectedTimeSlot,
            ),
          );
        }
      },
    );
  }

  /// Update selected time slot.
  void selectTimeSlot(TimeSlotEntity slot) {
    _selectedTimeSlot = slot;
    final currentState = state;
    if (currentState is TimeSlotsLoaded) {
      emit(
        currentState.copyWith(
          selectedSlot: slot,
          selectedDate: _selectedDate,
          fieldId: _currentFieldId,
        ),
      );
    }
  }

  /// Reset to initial state.
  void reset() {
    _selectedDate = DateTime.now();
    _selectedTimeSlot = null;
    _currentFieldId = null;
    emit(const TimeSlotInitial());
  }
}
