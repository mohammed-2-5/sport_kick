import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class ManualBookingValidator {
  static String? validateStepOne({
    required AppLocalizations l10n,
    required FieldEntity? field,
    required DateTime? date,
    required String? startTime,
    required String? endTime,
    required double? price,
  }) {
    if (field == null) {
      return l10n.manualBookingSelectField;
    }
    if (date == null) {
      return l10n.manualBookingSelectDate;
    }
    if (startTime == null || endTime == null) {
      return l10n.manualBookingSelectTimeSlot;
    }
    if (price == null || price <= 0) {
      return l10n.manualBookingEnterValidPrice;
    }
    return null;
  }

  static String? validateStepTwo({
    required AppLocalizations l10n,
    required String? customerName,
    required String? customerPhone,
  }) {
    if (customerName == null || customerName.isEmpty) {
      return l10n.manualBookingEnterCustomerName;
    }
    if (customerPhone == null || customerPhone.isEmpty) {
      return l10n.manualBookingEnterCustomerPhone;
    }
    return null;
  }
}
