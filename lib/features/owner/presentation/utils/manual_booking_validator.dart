import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

class ManualBookingValidator {
  static String? validateStepOne({
    required FieldEntity? field,
    required DateTime? date,
    required String? startTime,
    required String? endTime,
    required double? price,
  }) {
    if (field == null) {
      return 'Please select a field';
    }
    if (date == null) {
      return 'Please select a date';
    }
    if (startTime == null || endTime == null) {
      return 'Please select a time slot';
    }
    if (price == null || price <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  static String? validateStepTwo({
    required String customerName,
    required String customerPhone,
  }) {
    if (customerName.isEmpty) {
      return 'Please enter customer name';
    }
    if (customerPhone.isEmpty) {
      return 'Please enter customer phone';
    }
    return null;
  }
}
