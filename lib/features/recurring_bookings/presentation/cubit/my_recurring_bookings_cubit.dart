import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/cancel_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_my_recurring_bookings_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';

/// Cubit for managing user's recurring bookings.
class MyRecurringBookingsCubit extends Cubit<MyRecurringBookingsState> {
  final GetMyRecurringBookingsUseCase _getMyRecurringBookingsUseCase;
  final CancelRecurringBookingUseCase _cancelRecurringBookingUseCase;

  MyRecurringBookingsCubit({
    required GetMyRecurringBookingsUseCase getMyRecurringBookingsUseCase,
    required CancelRecurringBookingUseCase cancelRecurringBookingUseCase,
  }) : _getMyRecurringBookingsUseCase = getMyRecurringBookingsUseCase,
       _cancelRecurringBookingUseCase = cancelRecurringBookingUseCase,
       super(const MyRecurringBookingsInitial());

  /// Load user's recurring bookings.
  Future<void> loadRecurringBookings() async {
    emit(const MyRecurringBookingsLoading());

    final result = await _getMyRecurringBookingsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [MyRecurringBookingsCubit] Load failed: ${failure.message}',
        );
        emit(MyRecurringBookingsError(failure.message));
      },
      (bookings) {
        debugPrint(
          '✅ [MyRecurringBookingsCubit] Loaded ${bookings.length} recurring bookings',
        );
        emit(MyRecurringBookingsLoaded(bookings: bookings));
      },
    );
  }

  /// Cancel a recurring booking.
  Future<bool> cancelRecurringBooking({
    required String recurringBookingId,
    String? reason,
  }) async {
    final currentState = state;
    if (currentState is! MyRecurringBookingsLoaded) return false;

    emit(
      MyRecurringBookingsActionInProgress(
        bookings: currentState.bookings,
        actionBookingId: recurringBookingId,
      ),
    );

    final result = await _cancelRecurringBookingUseCase(
      CancelRecurringBookingParams(
        recurringBookingId: recurringBookingId,
        reason: reason,
      ),
    );

    return result.fold(
      (failure) {
        debugPrint(
          '❌ [MyRecurringBookingsCubit] Cancel failed: ${failure.message}',
        );
        emit(MyRecurringBookingsLoaded(bookings: currentState.bookings));
        return false;
      },
      (success) {
        debugPrint('✅ [MyRecurringBookingsCubit] Canceled successfully');
        // Reload to get updated list
        loadRecurringBookings();
        return true;
      },
    );
  }

  /// Refresh bookings.
  Future<void> refresh() => loadRecurringBookings();
}
