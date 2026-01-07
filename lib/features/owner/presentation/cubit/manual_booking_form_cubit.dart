import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_end_time_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/calculate_booking_price_usecase.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/manual_booking_validator.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

/// Cubit for managing manual booking form wizard state.
///
/// Handles:
/// - Step navigation with validation
/// - Form data management
/// - End time auto-calculation
/// - Optional initialization from booking table
class ManualBookingFormCubit extends Cubit<ManualBookingFormState> {
  final CalculateBookingEndTimeUseCase _calculateBookingEndTimeUseCase;
  final CalculateBookingPriceUseCase _calculateBookingPriceUseCase;

  ManualBookingFormCubit({
    required CalculateBookingEndTimeUseCase calculateBookingEndTimeUseCase,
    required CalculateBookingPriceUseCase calculateBookingPriceUseCase,
  }) : _calculateBookingEndTimeUseCase = calculateBookingEndTimeUseCase,
       _calculateBookingPriceUseCase = calculateBookingPriceUseCase,
       super(const ManualBookingFormInitial());

  /// Initialize form with data from booking table.
  ///
  /// Expects map with keys:
  /// - 'fieldId': String
  /// - 'fieldName': String
  /// - 'selectedDate': DateTime
  /// - 'selectedTime': String (HH:mm format)
  void initializeWithData(Map<String, dynamic>? initialData) {
    if (initialData == null) return;

    try {
      final date = initialData['selectedDate'] as DateTime?;
      final startTime = initialData['selectedTime'] as String?;

      // Calculate end time (1 hour after start)
      final endTime = startTime != null
          ? _calculateBookingEndTimeUseCase(
              startTime: startTime,
              durationHours: 1,
            )
          : null;

      // Store fieldId/fieldName for later use when fields are loaded
      final newData = _data.copyWith(
        selectedDate: date,
        selectedStartTime: startTime,
        selectedEndTime: endTime,
      );

      emit(ManualBookingFormInitial(data: newData));
    } catch (e) {
      // Silently fail initialization, user can fill manually
    }
  }

  ManualBookingFormData get _data {
    final currentState = state;
    if (currentState is ManualBookingFormInitial) {
      return currentState.data;
    }
    if (currentState is ManualBookingFormStepChanged) {
      return currentState.data;
    }
    if (currentState is ManualBookingFormValidationError) {
      return currentState.data;
    }
    if (currentState is ManualBookingFormReadyToSubmit) {
      return currentState.data;
    }
    return const ManualBookingFormData();
  }

  /// Navigate to next step with validation.
  void nextStep(AppLocalizations l10n) {
    final currentStep = _data.currentStep;

    if (currentStep == 0) {
      final error = ManualBookingValidator.validateStepOne(
        l10n: l10n,
        field: _data.selectedField,
        date: _data.selectedDate,
        startTime: _data.selectedStartTime,
        endTime: _data.selectedEndTime,
        price: _data.totalPrice,
      );

      if (error != null) {
        emit(ManualBookingFormValidationError(data: _data, message: error));
        return;
      }

      _goToStep(1);
    } else if (currentStep == 1) {
      final error = ManualBookingValidator.validateStepTwo(
        l10n: l10n,
        customerName: _data.customerName,
        customerPhone: _data.customerPhone,
      );

      if (error != null) {
        emit(ManualBookingFormValidationError(data: _data, message: error));
        return;
      }

      _goToStep(2);
    } else if (currentStep == 2) {
      emit(ManualBookingFormReadyToSubmit(data: _data));
    }
  }

  /// Navigate to previous step.
  void previousStep() {
    if (_data.currentStep > 0) {
      _goToStep(_data.currentStep - 1);
    }
  }

  /// Navigate to a specific step.
  void goToStep(int step) {
    if (step >= 0 && step <= 2 && step != _data.currentStep) {
      _goToStep(step);
    }
  }

  /// Internal helper to navigate to step.
  void _goToStep(int step) {
    final newData = _data.copyWith(currentStep: step);
    emit(ManualBookingFormStepChanged(data: newData, targetStep: step));
  }

  /// Get current step index.
  int get currentStep => _data.currentStep;

  /// Get current form data.
  ManualBookingFormData get formData => _data;

  /// Validate and prepare for submission.
  void prepareSubmission() {
    emit(ManualBookingFormReadyToSubmit(data: _data));
  }

  /// Update selected field (clears time selections and recalculates price).
  void setField(FieldEntity? field) {
    final price = field != null
        ? _calculateBookingPriceUseCase(
            pricePerHour: field.pricePerHour,
            durationHours: _data.durationHours,
          )
        : null;

    final newData = _data.copyWith(
      selectedField: field,
      totalPrice: price,
      clearStartTime: true,
      clearEndTime: true,
    );
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update selected date (clears time selections).
  void setDate(DateTime? date) {
    final newData = _data.copyWith(
      selectedDate: date,
      clearStartTime: true,
      clearEndTime: true,
    );
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update start time and auto-calculate end time based on duration.
  void setStartTime(String? time) {
    final endTime = time != null
        ? _calculateBookingEndTimeUseCase(
            startTime: time,
            durationHours: _data.durationHours,
          )
        : null;

    final newData = _data.copyWith(
      selectedStartTime: time,
      selectedEndTime: endTime,
    );
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update end time.
  void setEndTime(String? time) {
    final newData = _data.copyWith(selectedEndTime: time);
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update duration (1 or 2 hours) and recalculate price and end time.
  void setDuration(int hours) {
    if (hours != 1 && hours != 2) return; // Only 1 or 2 hours allowed

    // Recalculate price based on field price per hour
    final price = _data.selectedField != null
        ? _calculateBookingPriceUseCase(
            pricePerHour: _data.selectedField!.pricePerHour,
            durationHours: hours,
          )
        : null;

    // Recalculate end time if start time exists
    final endTime = _data.selectedStartTime != null
        ? _calculateBookingEndTimeUseCase(
            startTime: _data.selectedStartTime!,
            durationHours: hours,
          )
        : null;

    final newData = _data.copyWith(
      durationHours: hours,
      totalPrice: price,
      selectedEndTime: endTime,
    );
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update total price (kept for backwards compatibility, but not used in UI).
  void setPrice(double? price) {
    final newData = _data.copyWith(totalPrice: price);
    emit(ManualBookingFormInitial(data: newData));
  }

  /// Update customer details.
  void setCustomerDetails({
    String? name,
    String? phone,
    String? email,
    String? notes,
  }) {
    final newData = _data.copyWith(
      customerName: name,
      customerPhone: phone,
      customerEmail: email,
      notes: notes,
    );
    emit(ManualBookingFormInitial(data: newData));
  }
}
