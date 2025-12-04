import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';

/// Validator for field creation form.
///
/// Validates all field form inputs and provides error messages.
class FieldFormValidator {
  const FieldFormValidator._();

  /// Validate field name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field name is required';
    }
    return null;
  }

  /// Validate address
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  /// Validate price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  /// Validate city selection
  static String? validateCity(String? value) {
    if (value == null) {
      return 'Please select a city';
    }
    return null;
  }

  /// Validate sport category selection
  static String? validateSportCategory(String? value) {
    if (value == null) {
      return 'Please select a sport category';
    }
    return null;
  }

  /// Validate admin selection
  static String? validateAdmin(UserEntity? admin) {
    if (admin == null) {
      return 'Please select an admin to assign this field';
    }
    return null;
  }

  /// Get capacity for selected size
  static int getCapacityForSize(String size) {
    return FieldFormConstants.getSizeCapacity(size);
  }
}
