import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for booking management operations.
///
/// Handles platform-wide booking access and management:
/// - Load all bookings
/// - Update booking status (confirm, cancel, complete)
/// - Cancel bookings with reason
mixin BookingOperations on Cubit<SuperAdminState> {
  // Dependencies
  GetAllBookingsUseCase get getAllBookingsUseCase;
  UpdateBookingStatusUseCase get updateBookingStatusUseCase;
  CancelBookingUseCase get cancelBookingUseCase;

  /// Load all bookings in the system.
  Future<void> loadAllBookings() async {
    debugPrint('🔄 [SuperAdminCubit] Loading all bookings...');
    emit(const SuperAdminLoading(message: 'Loading bookings...'));

    final result = await getAllBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading bookings: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (bookings) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${bookings.length} bookings');
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
      '🔄 [SuperAdminCubit] Updating booking $bookingId to ${status.displayName}',
    );
    emit(const SuperAdminLoading(message: 'Updating booking status...'));

    final result = await updateBookingStatusUseCase(
      bookingId: bookingId,
      status: status,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error updating booking: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (booking) {
        debugPrint('✅ [SuperAdminCubit] Booking status updated successfully');
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
    debugPrint('🔄 [SuperAdminCubit] Cancelling booking $bookingId');
    emit(const SuperAdminLoading(message: 'Cancelling booking...'));

    final result = await cancelBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error cancelling booking: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (booking) {
        debugPrint('✅ [SuperAdminCubit] Booking cancelled successfully');
        emit(BookingCancelled(bookingId: bookingId));
        // Reload bookings to show updated list
        loadAllBookings();
      },
    );
  }
}
