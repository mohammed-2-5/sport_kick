import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// States for manual booking form wizard.
abstract class ManualBookingFormState extends Equatable {
  const ManualBookingFormState();
}

/// Form data holder for manual booking.
class ManualBookingFormData extends Equatable {
  final int currentStep;
  final FieldEntity? selectedField;
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final int durationHours; // 1 or 2 hours
  final double? totalPrice;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? notes;

  const ManualBookingFormData({
    this.currentStep = 0,
    this.selectedField,
    this.selectedDate,
    this.selectedStartTime,
    this.selectedEndTime,
    this.durationHours = 1, // Default 1 hour
    this.totalPrice,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.notes,
  });

  ManualBookingFormData copyWith({
    int? currentStep,
    FieldEntity? selectedField,
    DateTime? selectedDate,
    String? selectedStartTime,
    String? selectedEndTime,
    int? durationHours,
    double? totalPrice,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? notes,
    bool clearStartTime = false,
    bool clearEndTime = false,
  }) {
    return ManualBookingFormData(
      currentStep: currentStep ?? this.currentStep,
      selectedField: selectedField ?? this.selectedField,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStartTime: clearStartTime
          ? null
          : (selectedStartTime ?? this.selectedStartTime),
      selectedEndTime: clearEndTime
          ? null
          : (selectedEndTime ?? this.selectedEndTime),
      durationHours: durationHours ?? this.durationHours,
      totalPrice: totalPrice ?? this.totalPrice,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    selectedField,
    selectedDate,
    selectedStartTime,
    selectedEndTime,
    durationHours,
    totalPrice,
    customerName,
    customerPhone,
    customerEmail,
    notes,
  ];
}

/// Initial state.
class ManualBookingFormInitial extends ManualBookingFormState {
  final ManualBookingFormData data;

  const ManualBookingFormInitial({this.data = const ManualBookingFormData()});

  @override
  List<Object?> get props => [data];
}

/// Step changed - triggers page animation.
class ManualBookingFormStepChanged extends ManualBookingFormState {
  final ManualBookingFormData data;
  final int targetStep;

  const ManualBookingFormStepChanged({
    required this.data,
    required this.targetStep,
  });

  @override
  List<Object?> get props => [data, targetStep];
}

/// Validation error on current step.
class ManualBookingFormValidationError extends ManualBookingFormState {
  final ManualBookingFormData data;
  final String message;

  const ManualBookingFormValidationError({
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [data, message];
}

/// Ready to submit - all data validated.
class ManualBookingFormReadyToSubmit extends ManualBookingFormState {
  final ManualBookingFormData data;

  const ManualBookingFormReadyToSubmit({required this.data});

  @override
  List<Object?> get props => [data];
}
