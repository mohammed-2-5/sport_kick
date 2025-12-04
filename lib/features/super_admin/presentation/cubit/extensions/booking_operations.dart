import 'package:flutter/foundation.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Extension for booking management operations.
///
/// Handles platform-wide booking access and reporting.
extension BookingOperations on SuperAdminCubit {
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
}
