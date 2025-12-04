import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_manual_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';

import '../../domain/entities/booking_status.dart';

/// Cubit for managing booking state.
///
/// Handles all booking-related business logic:
/// - Fetching available time slots
/// - Creating bookings (regular and manual)
/// - Fetching user bookings
/// - Fetching booking details
/// - Canceling bookings
class BookingCubit extends Cubit<BookingState> {
  final GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final CreateManualBookingUseCase createManualBookingUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetBookingByIdUseCase getBookingByIdUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final GetOwnerBookingsUseCase getOwnerBookingsUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;

  BookingCubit({
    required this.getAvailableTimeSlotsUseCase,
    required this.createBookingUseCase,
    required this.createManualBookingUseCase,
    required this.getUserBookingsUseCase,
    required this.getBookingByIdUseCase,
    required this.cancelBookingUseCase,
    required this.getOwnerBookingsUseCase,
    required this.updateBookingStatusUseCase,
  }) : super(const BookingInitial());

  /// Load available time slots for a field on a specific date.
  Future<void> loadAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  }) async {
    emit(const BookingLoading(message: 'Loading available time slots...'));

    final result = await getAvailableTimeSlotsUseCase(
      fieldId: fieldId,
      date: date,
    );

    result.fold(
      (failure) {
        debugPrint('❌ ERROR [loadAvailableTimeSlots]: ${failure.message}');
        emit(BookingError(failure.message));
      },
      (timeSlots) {
        if (timeSlots.isEmpty) {
          emit(
            const BookingsEmpty(
              message: 'No time slots available for this date.',
            ),
          );
        } else {
          emit(
            TimeSlotsLoaded(
              timeSlots: timeSlots,
              selectedDate: date,
              fieldId: fieldId,
            ),
          );
        }
      },
    );
  }

  /// Create a new booking.
  Future<void> createBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    String? notes,
  }) async {
    emit(const BookingLoading(message: 'Creating booking...'));

    final result = await createBookingUseCase(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      notes: notes,
    );

    result.fold((failure) {
      debugPrint('❌ ERROR [createBooking]: ${failure.message}');
      emit(BookingError(failure.message));
    }, (booking) => emit(BookingCreated(booking)));
  }

  /// Create a manual booking (for field owners/admins).
  ///
  /// Manual bookings are created by admins for walk-in customers.
  /// They are automatically confirmed and include customer information.
  Future<void> createManualBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? notes,
  }) async {
    debugPrint('🔄 [BookingCubit] Creating manual booking...');
    debugPrint('   Customer: $customerName ($customerPhone)');
    debugPrint('   Field: $fieldId, Date: $date, Time: $startTime-$endTime');

    emit(const BookingLoading(message: 'Creating manual booking...'));

    final result = await createManualBookingUseCase(
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalPrice: totalPrice,
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      notes: notes,
    );

    result.fold(
      (failure) {
        debugPrint('❌ ERROR [createManualBooking]: ${failure.message}');
        emit(BookingError(failure.message));
      },
      (booking) {
        debugPrint('✅ [BookingCubit] Manual booking created: ${booking.id}');
        emit(BookingCreated(booking));
      },
    );
  }

  /// Load all bookings for the current user.
  Future<void> loadUserBookings() async {
    emit(const BookingLoading(message: 'Loading your bookings...'));

    final result = await getUserBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint('❌ ERROR [loadUserBookings]: ${failure.message}');
        emit(BookingError(failure.message));
      },
      (bookings) {
        if (bookings.isEmpty) {
          emit(const BookingsEmpty(message: 'You have no bookings yet.'));
        } else {
          emit(BookingsLoaded(bookings));
        }
      },
    );
  }

  /// Load a single booking by ID.
  Future<void> loadBookingById(String bookingId) async {
    emit(const BookingLoading(message: 'Loading booking details...'));

    final result = await getBookingByIdUseCase(bookingId);

    result.fold((failure) {
      debugPrint('❌ ERROR [loadBookingById]: ${failure.message}');
      emit(BookingError(failure.message));
    }, (booking) => emit(BookingDetailsLoaded(booking)));
  }

  /// Cancel a booking.
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    emit(const BookingLoading(message: 'Canceling booking...'));

    final result = await cancelBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold((failure) {
      debugPrint('❌ ERROR [cancelBooking]: ${failure.message}');
      emit(BookingError(failure.message));
    }, (booking) => emit(BookingCanceled(booking)));
  }

  /// Reset to initial state.
  void reset() {
    emit(const BookingInitial());
  }

  /// Refresh bookings after a successful operation.
  Future<void> refreshBookings() async {
    await loadUserBookings();
  }

  /// Load all bookings for the field owner.
  ///
  /// Fetches bookings for all fields owned by the current user.
  Future<void> loadOwnerBookings() async {
    debugPrint('🔄 [BookingCubit] Loading owner bookings...');
    emit(const BookingLoading(message: 'Loading bookings...'));

    final result = await getOwnerBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint('❌ ERROR [loadOwnerBookings]: ${failure.message}');
        emit(BookingError(failure.message));
      },
      (bookings) {
        debugPrint('✅ [BookingCubit] Loaded ${bookings.length} owner bookings');
        if (bookings.isEmpty) {
          emit(const BookingsEmpty(message: 'No bookings found.'));
        } else {
          emit(BookingsLoaded(bookings));
        }
      },
    );
  }

  /// Update booking status (for owners to approve/reject bookings).
  ///
  /// Updates the booking status in the backend and reloads the owner's bookings.
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    debugPrint(
      '🔄 [BookingCubit] Updating booking $bookingId to ${newStatus.displayName}',
    );
    emit(const BookingLoading(message: 'Updating booking...'));

    final result = await updateBookingStatusUseCase(
      bookingId: bookingId,
      status: newStatus,
    );

    result.fold(
      (failure) {
        debugPrint('❌ ERROR [updateBookingStatus]: ${failure.message}');
        emit(BookingError(failure.message));
      },
      (updatedBooking) async {
        debugPrint('✅ [BookingCubit] Booking updated successfully');
        // Reload all bookings to reflect the change
        await loadOwnerBookings();
      },
    );
  }
}
