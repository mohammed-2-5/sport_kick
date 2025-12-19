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
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
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
  DateTime _selectedDate = DateTime.now();
  TimeSlotEntity? _selectedTimeSlot;
  String? _currentFieldId;

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

  DateTime get selectedDate => _selectedDate;
  TimeSlotEntity? get selectedTimeSlot => _selectedTimeSlot;
  String? get currentFieldId => _currentFieldId;

  /// Initialize booking flow for a given field.
  ///
  /// Stores the field, sets the initial date, and triggers the initial
  /// time-slot load. Keeps UI free of orchestration logic.
  Future<void> startBookingFlow(String fieldId, {DateTime? initialDate}) async {
    _selectedDate = initialDate ?? DateTime.now();
    _currentFieldId = fieldId;
    await loadAvailableTimeSlots(fieldId: fieldId, date: _selectedDate);
  }

  /// Change selected date and reload slots for the current field.
  Future<void> changeSelectedDate(DateTime date) async {
    _selectedDate = date;
    if (_currentFieldId == null) {
      emit(const BookingError(BookingConstants.selectDateFirstMessage));
      return;
    }
    await loadAvailableTimeSlots(fieldId: _currentFieldId!, date: date);
  }

  /// Load available time slots for a field on a specific date.
  Future<void> loadAvailableTimeSlots({
    required String fieldId,
    required DateTime date,
  }) async {
    _selectedDate = date;
    _currentFieldId = fieldId;
    _selectedTimeSlot = null;
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
          emit(const BookingsEmpty());
        } else {
          emit(
            TimeSlotsLoaded(
              timeSlots: timeSlots,
              selectedDate: date,
              fieldId: fieldId,
              selectedSlot: _selectedTimeSlot,
            ),
          );
        }
      },
    );
  }

  /// Update selected time slot.
  void selectTimeSlot(TimeSlotEntity slot) {
    _selectedTimeSlot = slot;
    final currentState = state;
    if (currentState is TimeSlotsLoaded) {
      emit(
        currentState.copyWith(
          selectedSlot: slot,
          selectedDate: _selectedDate,
          fieldId: _currentFieldId,
        ),
      );
    }
  }

  /// Create a booking using current selection.
  Future<void> createBookingFromSelection() async {
    if (_currentFieldId == null || _selectedTimeSlot == null) {
      emit(const BookingError(BookingConstants.selectTimeSlotFirstMessage));
      return;
    }

    await createBooking(
      fieldId: _currentFieldId!,
      date: _selectedDate,
      startTime: _selectedTimeSlot!.startTime,
      endTime: _selectedTimeSlot!.endTime,
      totalPrice: _selectedTimeSlot!.price,
      notes: null,
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
          emit(const BookingsEmpty());
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
          emit(const BookingsEmpty());
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
