import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';

/// Remote data source for owner operations
abstract class OwnerRemoteDataSource {
  /// Get all fields owned by a specific owner
  Future<List<FieldModel>> getOwnerFields(String ownerId);

  /// Update field details
  Future<FieldModel> updateField(String fieldId, Map<String, dynamic> updates);

  /// Get all bookings for owner's fields
  Future<List<BookingModel>> getOwnerBookings({
    required String ownerId,
    String? status,
  });

  /// Approve a pending booking
  Future<void> approveBooking(String bookingId);

  /// Reject a booking with a reason
  Future<void> rejectBooking(String bookingId, String reason);

  /// Get revenue data for owner
  Future<Map<String, dynamic>> getOwnerRevenue(String ownerId);

  /// Update owner profile information
  Future<void> updateOwnerProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  });
}
