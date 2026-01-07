import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/booking_management/booking_management_state.dart';

/// Cubit for booking management operations.
///
/// Handles platform-wide booking access and management:
/// - Load all bookings
/// - Update booking status (confirm, cancel, complete)
/// - Cancel bookings with reason
class BookingManagementCubit extends Cubit<BookingManagementState> {
  final GetAllBookingsUseCase getAllBookingsUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;
  final CancelBookingUseCase cancelBookingUseCase;

  BookingManagementCubit({
    required this.getAllBookingsUseCase,
    required this.updateBookingStatusUseCase,
    required this.cancelBookingUseCase,
  }) : super(const BookingManagementInitial());

  /// Load all bookings in the system.
  Future<void> loadAllBookings() async {
    debugPrint('🔄 [BookingManagementCubit] Loading all bookings...');
    emit(const BookingManagementLoading(message: 'Loading bookings...'));

    final result = await getAllBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [BookingManagementCubit] Error loading bookings: ${failure.message}',
        );
        emit(BookingManagementError(failure.message));
      },
      (bookings) {
        debugPrint(
          '✅ [BookingManagementCubit] Loaded ${bookings.length} bookings',
        );
        emit(AllBookingsLoaded(bookings));
      },
    );
  }

  /// Update booking status.
  ///
  /// Used by super admin to confirm, reject, or complete bookings.
  Future<void> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
  }) async {
    debugPrint(
      '🔄 [BookingManagementCubit] Updating booking $bookingId to ${status.displayName}',
    );
    emit(const BookingManagementLoading(message: 'Updating booking status...'));

    final result = await updateBookingStatusUseCase(
      bookingId: bookingId,
      status: status,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [BookingManagementCubit] Error updating booking: ${failure.message}',
        );
        emit(BookingManagementError(failure.message));
      },
      (booking) {
        debugPrint(
          '✅ [BookingManagementCubit] Booking status updated successfully',
        );
        emit(
          BookingStatusUpdated(
            bookingId: bookingId,
            newStatus: status.displayName,
          ),
        );
        // Reload bookings to show updated list
        loadAllBookings();
      },
    );
  }

  /// Cancel a booking with reason.
  ///
  /// Used by super admin to cancel any booking on the platform.
  Future<void> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    debugPrint('🔄 [BookingManagementCubit] Cancelling booking $bookingId');
    emit(const BookingManagementLoading(message: 'Cancelling booking...'));

    final result = await cancelBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [BookingManagementCubit] Error cancelling booking: ${failure.message}',
        );
        emit(BookingManagementError(failure.message));
      },
      (booking) {
        debugPrint('✅ [BookingManagementCubit] Booking cancelled successfully');
        emit(BookingCancelled(bookingId: bookingId));
        // Reload bookings to show updated list
        loadAllBookings();
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    emit(const BookingManagementInitial());
  }
}
