import 'package:spo_kick/features/business_hours/data/models/business_hours_model.dart';

/// Remote data source interface for business hours operations.
///
/// Defines the contract for fetching and updating business hours data
/// from the remote backend (Supabase).
abstract class BusinessHoursRemoteDataSource {
  /// Fetches business hours for a specific field.
  ///
  /// Returns a list of [BusinessHoursModel] for all 7 days.
  /// Throws an exception if the operation fails.
  Future<List<BusinessHoursModel>> getFieldBusinessHours(String fieldId);

  /// Updates business hours for a specific day.
  ///
  /// Returns the updated [BusinessHoursModel].
  /// Throws an exception if the operation fails.
  Future<BusinessHoursModel> updateBusinessHours({
    required String fieldId,
    required int dayOfWeek,
    required bool isOpen,
    String? openingTime,
    String? closingTime,
  });

  /// Updates business hours for multiple days at once.
  ///
  /// Returns list of updated [BusinessHoursModel].
  /// Throws an exception if the operation fails.
  Future<List<BusinessHoursModel>> updateMultipleBusinessHours({
    required String fieldId,
    required Map<int, BusinessHoursModel> updates,
  });

  /// Initializes default business hours (24/7) for a field.
  ///
  /// Calls the database function to create default hours.
  /// Throws an exception if the operation fails.
  Future<void> initializeDefaultBusinessHours(String fieldId);

  /// Validates if a booking time is within business hours.
  ///
  /// Calls the database function to validate the booking time.
  /// Returns true if valid, false otherwise.
  /// Throws an exception if the operation fails.
  Future<bool> validateBookingTime({
    required String fieldId,
    required DateTime bookingTime,
  });

  /// Checks if a field is currently open.
  ///
  /// Calculates based on current day and time.
  /// Returns true if open, false if closed.
  /// Throws an exception if the operation fails.
  Future<bool> isFieldCurrentlyOpen(String fieldId);

  /// Gets the next opening time for a field.
  ///
  /// Returns [DateTime] of next opening or null if closed for 7+ days.
  /// Throws an exception if the operation fails.
  Future<DateTime?> getNextOpeningTime({
    required String fieldId,
    DateTime? fromTime,
  });
}
