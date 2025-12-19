import 'package:flutter_bloc/flutter_bloc.dart';
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
  ManualBookingFormCubit() : super(const ManualBookingFormInitial());

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
      String? endTime;
      if (startTime != null) {
        final hour = int.parse(startTime.split(':')[0]);
        if (hour < 23) {
          endTime = '${(hour + 1).toString().padLeft(2, '0')}:00';
        }
      }

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
        ? field.pricePerHour * _data.durationHours
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
    String? endTime;
    if (time != null) {
      final hour = int.parse(time.split(':')[0]);
      final minute = int.parse(time.split(':')[1]);

      // Calculate end time based on duration (1 or 2 hours)
      final endHour = hour + _data.durationHours;

      if (endHour < 24) {
        endTime =
            '${endHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }
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
        ? _data.selectedField!.pricePerHour * hours
        : null;

    // Recalculate end time if start time exists
    String? endTime = _data.selectedEndTime;
    if (_data.selectedStartTime != null) {
      final hour = int.parse(_data.selectedStartTime!.split(':')[0]);
      final minute = int.parse(_data.selectedStartTime!.split(':')[1]);
      final endHour = hour + hours;

      if (endHour < 24) {
        endTime =
            '${endHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }

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
