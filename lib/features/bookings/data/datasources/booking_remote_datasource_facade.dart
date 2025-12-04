import 'package:spo_kick/features/bookings/data/datasources/booking_admin_operations_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_owner_operations_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_time_slot_datasource.dart';
import 'package:spo_kick/features/bookings/data/datasources/booking_user_operations_datasource.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Facade datasource that maintains backward compatibility with the original
/// BookingRemoteDataSource interface by delegating to specialized datasources.
///
/// This implements the Facade pattern to provide a unified interface while
/// the implementation is split across multiple focused datasources:
/// - User booking operations (CRUD for users)
/// - Time slot operations (availability checking)
/// - Owner operations (field owner management)
/// - Admin operations (super admin platform-wide access)
///
/// This allows the repository layer to remain unchanged while we improve
/// code organization and maintainability at the datasource layer.
abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getUserBookings(String userId);
  Future<BookingModel> getBookingById(String bookingId);
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  });
  Future<BookingModel> createBooking(BookingModel booking);
  Future<BookingModel> cancelBooking(String bookingId, String reason);
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  );
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  );
  Future<List<BookingModel>> getOwnerBookings();
  Future<List<BookingModel>> getAllBookings();
  Future<BookingModel> createManualBooking(BookingModel booking);
}

/// Implementation of the facade that delegates to specialized datasources.
class BookingRemoteDataSourceFacade implements BookingRemoteDataSource {
  final BookingUserOperationsDataSource _userOperationsDataSource;
  final BookingTimeSlotDataSource _timeSlotDataSource;
  final BookingOwnerOperationsDataSource _ownerOperationsDataSource;
  final BookingAdminOperationsDataSource _adminOperationsDataSource;

  BookingRemoteDataSourceFacade({
    required BookingUserOperationsDataSource userOperationsDataSource,
    required BookingTimeSlotDataSource timeSlotDataSource,
    required BookingOwnerOperationsDataSource ownerOperationsDataSource,
    required BookingAdminOperationsDataSource adminOperationsDataSource,
  }) : _userOperationsDataSource = userOperationsDataSource,
       _timeSlotDataSource = timeSlotDataSource,
       _ownerOperationsDataSource = ownerOperationsDataSource,
       _adminOperationsDataSource = adminOperationsDataSource;

  // ==================== User Booking Operations ====================

  @override
  Future<List<BookingModel>> getUserBookings(String userId) {
    return _userOperationsDataSource.getUserBookings(userId);
  }

  @override
  Future<BookingModel> getBookingById(String bookingId) {
    return _userOperationsDataSource.getBookingById(bookingId);
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) {
    return _userOperationsDataSource.createBooking(booking);
  }

  @override
  Future<BookingModel> cancelBooking(String bookingId, String reason) {
    return _userOperationsDataSource.cancelBooking(bookingId, reason);
  }

  @override
  Future<List<BookingModel>> getBookingsByStatus(
    String userId,
    BookingStatus status,
  ) {
    return _userOperationsDataSource.getBookingsByStatus(userId, status);
  }

  // ==================== Time Slot Operations ====================

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  }) {
    return _timeSlotDataSource.getAvailableTimeSlots(
      fieldId: fieldId,
      date: date,
    );
  }

  // ==================== Owner Operations ====================

  @override
  Future<List<BookingModel>> getOwnerBookings() {
    return _ownerOperationsDataSource.getOwnerBookings();
  }

  @override
  Future<BookingModel> createManualBooking(BookingModel booking) {
    return _ownerOperationsDataSource.createManualBooking(booking);
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) {
    return _ownerOperationsDataSource.updateBookingStatus(bookingId, status);
  }

  // ==================== Admin Operations ====================

  @override
  Future<List<BookingModel>> getAllBookings() {
    return _adminOperationsDataSource.getAllBookings();
  }
}
