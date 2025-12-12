import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/manual_booking_form_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/manual_booking_validator.dart';

/// Cubit for managing manual booking form wizard state.
///
/// Handles:
/// - Step navigation with validation
/// - Form data management
/// - End time auto-calculation
class ManualBookingFormCubit extends Cubit<ManualBookingFormState> {
  ManualBookingFormCubit() : super(const ManualBookingFormInitial());

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
  void nextStep() {
    final currentStep = _data.currentStep;

    if (currentStep == 0) {
      final error = ManualBookingValidator.validateStepOne(
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

  /// Update selected field (clears time selections).
  void setField(FieldEntity? field) {
    final newData = _data.copyWith(
      selectedField: field,
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

  /// Update start time and auto-calculate end time.
  void setStartTime(String? time) {
    String? endTime;
    if (time != null) {
      final hour = int.parse(time.split(':')[0]);
      if (hour < 23) {
        endTime = '${(hour + 1).toString().padLeft(2, '0')}:00';
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

  /// Update total price.
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
