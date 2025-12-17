import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/create_recurring_request_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_reserved_slots_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_state.dart';

/// Cubit for creating a recurring booking request.
class CreateRecurringCubit extends Cubit<CreateRecurringState> {
  final CreateRecurringRequestUseCase _createRecurringRequestUseCase;
  final GetReservedSlotsUseCase _getReservedSlotsUseCase;

  CreateRecurringCubit({
    required CreateRecurringRequestUseCase createRecurringRequestUseCase,
    required GetReservedSlotsUseCase getReservedSlotsUseCase,
    required FieldEntity field,
  }) : _createRecurringRequestUseCase = createRecurringRequestUseCase,
       _getReservedSlotsUseCase = getReservedSlotsUseCase,
       super(CreateRecurringEditing(field: field)) {
    _loadReservedSlots(field.id);
  }

  /// Load reserved slots for the field.
  Future<void> _loadReservedSlots(String fieldId) async {
    final currentState = state;
    if (currentState is! CreateRecurringEditing) return;

    emit(currentState.copyWith(isLoadingSlots: true));

    final result = await _getReservedSlotsUseCase(
      GetReservedSlotsParams(fieldId: fieldId),
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CreateRecurringCubit] Load reserved slots failed: ${failure.message}',
        );
        emit(currentState.copyWith(isLoadingSlots: false));
      },
      (slots) {
        debugPrint(
          '✅ [CreateRecurringCubit] Loaded ${slots.length} reserved slots',
        );
        emit(
          currentState.copyWith(reservedSlots: slots, isLoadingSlots: false),
        );
      },
    );
  }

  /// Select day of week.
  void selectDayOfWeek(int dayOfWeek) {
    final currentState = state;
    if (currentState is! CreateRecurringEditing) return;

    emit(
      currentState.copyWith(
        selectedDayOfWeek: dayOfWeek,
        clearTime: true, // Clear time when day changes
        clearError: true,
      ),
    );
  }

  /// Select time slot.
  void selectTime(String time) {
    final currentState = state;
    if (currentState is! CreateRecurringEditing) return;

    // Check if slot is reserved
    if (currentState.selectedDayOfWeek != null &&
        currentState.isSlotReserved(currentState.selectedDayOfWeek!, time)) {
      emit(
        currentState.copyWith(
          errorMessage: 'This slot is already reserved by another user.',
        ),
      );
      return;
    }

    emit(currentState.copyWith(selectedTime: time, clearError: true));
  }

  /// Set duration (1 or 2 hours).
  void setDuration(int hours) {
    final currentState = state;
    if (currentState is! CreateRecurringEditing) return;

    if (hours != 1 && hours != 2) return;

    emit(currentState.copyWith(durationHours: hours, clearError: true));
  }

  /// Submit the recurring booking request.
  Future<void> submit() async {
    final currentState = state;
    if (currentState is! CreateRecurringEditing) return;

    if (!currentState.isValid) {
      emit(
        currentState.copyWith(
          errorMessage: 'Please select a day and time slot.',
        ),
      );
      return;
    }

    emit(const CreateRecurringSubmitting());

    final result = await _createRecurringRequestUseCase(
      CreateRecurringRequestParams(
        fieldId: currentState.field.id,
        dayOfWeek: currentState.selectedDayOfWeek!,
        startTime: currentState.selectedTime!,
        durationHours: currentState.durationHours,
      ),
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [CreateRecurringCubit] Submit failed: ${failure.message}',
        );
        emit(
          CreateRecurringError(
            message: failure.message,
            field: currentState.field,
          ),
        );
      },
      (recurringBookingId) {
        debugPrint(
          '✅ [CreateRecurringCubit] Request submitted: $recurringBookingId',
        );
        emit(CreateRecurringSuccess(recurringBookingId));
      },
    );
  }

  /// Reset to editing state after error.
  void resetAfterError() {
    final currentState = state;
    if (currentState is CreateRecurringError) {
      emit(CreateRecurringEditing(field: currentState.field));
      _loadReservedSlots(currentState.field.id);
    }
  }
}
