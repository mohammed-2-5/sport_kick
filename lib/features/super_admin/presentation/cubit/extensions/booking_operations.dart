import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for booking management operations.
///
/// Handles platform-wide booking access and reporting.
mixin BookingOperations on Cubit<SuperAdminState> {
  // Dependencies
  GetAllBookingsUseCase get getAllBookingsUseCase;

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
