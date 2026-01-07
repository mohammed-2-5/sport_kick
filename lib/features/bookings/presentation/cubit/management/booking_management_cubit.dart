import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_booking_by_id_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_user_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/management/booking_management_state.dart';

/// Cubit for managing user booking state.
///
/// Handles user booking operations:
/// - Loading user's bookings list
/// - Loading single booking details
/// - Canceling bookings
/// - Refreshing bookings after operations
class BookingManagementCubit extends Cubit<BookingManagementState> {
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final GetBookingByIdUseCase getBookingByIdUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingManagementCubit({
    required this.getUserBookingsUseCase,
    required this.getBookingByIdUseCase,
    required this.cancelBookingUseCase,
  }) : super(const BookingManagementInitial());

  /// Load all bookings for the current user.
  Future<void> loadUserBookings({required String loadingMessage}) async {
    emit(BookingManagementLoading(message: loadingMessage));

    final result = await getUserBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ ERROR [BookingManagementCubit.loadUserBookings]: ${failure.message}',
        );
        emit(BookingManagementError(failure.message));
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
  Future<void> loadBookingById(
    String bookingId, {
    required String loadingMessage,
  }) async {
    emit(BookingManagementLoading(message: loadingMessage));

    final result = await getBookingByIdUseCase(bookingId);

    result.fold((failure) {
      debugPrint(
        '❌ ERROR [BookingManagementCubit.loadBookingById]: ${failure.message}',
      );
      emit(BookingManagementError(failure.message));
    }, (booking) => emit(BookingDetailsLoaded(booking)));
  }

  /// Cancel a booking.
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
    required String loadingMessage,
  }) async {
    emit(BookingManagementLoading(message: loadingMessage));

    final result = await cancelBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold((failure) {
      debugPrint(
        '❌ ERROR [BookingManagementCubit.cancelBooking]: ${failure.message}',
      );
      emit(BookingManagementError(failure.message));
    }, (booking) => emit(BookingCanceled(booking)));
  }

  /// Refresh bookings after a successful operation.
  Future<void> refreshBookings() async {
    // We use a safe default here as this is often an internal refresh
    await loadUserBookings(loadingMessage: 'Loading your bookings...');
  }

  /// Reset to initial state.
  void reset() {
    emit(const BookingManagementInitial());
  }
}
