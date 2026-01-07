import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_approval_state.dart';

/// Cubit for managing owner bookings approval operations.
///
/// Handles booking loading, approval, and rejection for field owners.
class OwnerBookingsApprovalCubit extends Cubit<OwnerBookingsApprovalState> {
  final GetOwnerBookingsUseCase getOwnerBookingsUseCase;
  final ApproveBookingUseCase approveBookingUseCase;
  final RejectBookingUseCase rejectBookingUseCase;

  OwnerBookingsApprovalCubit({
    required this.getOwnerBookingsUseCase,
    required this.approveBookingUseCase,
    required this.rejectBookingUseCase,
  }) : super(const OwnerBookingsApprovalInitial());

  /// Load all bookings for owner's fields
  Future<void> loadOwnerBookings({
    required String ownerId,
    String? status,
  }) async {
    debugPrint(
      '🔄 [OwnerBookingsApprovalCubit] Loading bookings for owner: $ownerId',
    );
    emit(const OwnerBookingsApprovalLoading(message: 'Loading bookings...'));

    final result = await getOwnerBookingsUseCase(
      ownerId: ownerId,
      status: status,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerBookingsApprovalCubit] Error loading bookings: ${failure.message}',
        );
        emit(OwnerBookingsApprovalError(failure.message));
      },
      (bookings) {
        debugPrint(
          '✅ [OwnerBookingsApprovalCubit] Loaded ${bookings.length} bookings',
        );
        emit(OwnerBookingsLoaded(bookings));
      },
    );
  }

  /// Approve a pending booking
  Future<void> approveBooking(String bookingId) async {
    debugPrint('🔄 [OwnerBookingsApprovalCubit] Approving booking: $bookingId');
    emit(const OwnerBookingsApprovalLoading(message: 'Approving booking...'));

    final result = await approveBookingUseCase(bookingId: bookingId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerBookingsApprovalCubit] Error approving booking: ${failure.message}',
        );
        emit(OwnerBookingsApprovalError(failure.message));
      },
      (_) {
        debugPrint(
          '✅ [OwnerBookingsApprovalCubit] Booking approved successfully',
        );
        emit(BookingApproved(bookingId));
      },
    );
  }

  /// Reject a booking with a reason
  Future<void> rejectBooking(String bookingId, String reason) async {
    debugPrint('🔄 [OwnerBookingsApprovalCubit] Rejecting booking: $bookingId');
    emit(const OwnerBookingsApprovalLoading(message: 'Rejecting booking...'));

    final result = await rejectBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerBookingsApprovalCubit] Error rejecting booking: ${failure.message}',
        );
        emit(OwnerBookingsApprovalError(failure.message));
      },
      (_) {
        debugPrint(
          '✅ [OwnerBookingsApprovalCubit] Booking rejected successfully',
        );
        emit(BookingRejected(bookingId, reason));
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [OwnerBookingsApprovalCubit] Resetting state');
    emit(const OwnerBookingsApprovalInitial());
  }
}
