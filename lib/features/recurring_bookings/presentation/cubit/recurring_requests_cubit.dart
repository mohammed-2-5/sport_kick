import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/approve_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_active_recurring_bookings_for_owner_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_pending_recurring_requests_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/reject_recurring_booking_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_state.dart';

/// Cubit for managing recurring booking requests (owner side).
class RecurringRequestsCubit extends Cubit<RecurringRequestsState> {
  final GetPendingRecurringRequestsUseCase _getPendingRequestsUseCase;
  final GetActiveRecurringBookingsForOwnerUseCase _getActiveBookingsUseCase;
  final ApproveRecurringBookingUseCase _approveUseCase;
  final RejectRecurringBookingUseCase _rejectUseCase;

  RecurringRequestsCubit({
    required GetPendingRecurringRequestsUseCase getPendingRequestsUseCase,
    required GetActiveRecurringBookingsForOwnerUseCase getActiveBookingsUseCase,
    required ApproveRecurringBookingUseCase approveUseCase,
    required RejectRecurringBookingUseCase rejectUseCase,
  }) : _getPendingRequestsUseCase = getPendingRequestsUseCase,
       _getActiveBookingsUseCase = getActiveBookingsUseCase,
       _approveUseCase = approveUseCase,
       _rejectUseCase = rejectUseCase,
       super(const RecurringRequestsInitial());

  /// Load pending requests and active subscriptions.
  Future<void> loadData() async {
    emit(const RecurringRequestsLoading());

    try {
      // Load both pending requests and active subscriptions in parallel
      final results = await Future.wait([
        _getPendingRequestsUseCase(),
        _getActiveBookingsUseCase(),
      ]);

      final pendingResult = results[0];
      final activeResult = results[1];

      final pendingRequests = pendingResult.fold((failure) {
        debugPrint(
          '❌ [RecurringRequestsCubit] Load pending failed: ${failure.message}',
        );
        return <dynamic>[];
      }, (requests) => requests);

      final activeSubscriptions = activeResult.fold((failure) {
        debugPrint(
          '❌ [RecurringRequestsCubit] Load active failed: ${failure.message}',
        );
        return <dynamic>[];
      }, (subscriptions) => subscriptions);

      debugPrint(
        '✅ [RecurringRequestsCubit] Loaded ${pendingRequests.length} pending, '
        '${activeSubscriptions.length} active',
      );

      emit(
        RecurringRequestsLoaded(
          pendingRequests: List.from(pendingRequests),
          activeSubscriptions: List.from(activeSubscriptions),
        ),
      );
    } catch (e) {
      debugPrint('❌ [RecurringRequestsCubit] Load error: $e');
      emit(RecurringRequestsError('Failed to load data: $e'));
    }
  }

  /// Approve a recurring booking request.
  Future<bool> approveRequest(String requestId) async {
    final currentState = state;
    if (currentState is! RecurringRequestsLoaded) return false;

    emit(currentState.copyWith(processingRequestId: requestId));

    final result = await _approveUseCase(
      ApproveRecurringBookingParams(recurringBookingId: requestId),
    );

    return result.fold(
      (failure) {
        debugPrint(
          '❌ [RecurringRequestsCubit] Approve failed: ${failure.message}',
        );
        emit(currentState.copyWith(clearProcessing: true));
        return false;
      },
      (success) {
        debugPrint('✅ [RecurringRequestsCubit] Approved successfully');
        loadData(); // Reload to refresh lists
        return true;
      },
    );
  }

  /// Reject a recurring booking request.
  Future<bool> rejectRequest(String requestId, String reason) async {
    final currentState = state;
    if (currentState is! RecurringRequestsLoaded) return false;

    emit(currentState.copyWith(processingRequestId: requestId));

    final result = await _rejectUseCase(
      RejectRecurringBookingParams(
        recurringBookingId: requestId,
        reason: reason,
      ),
    );

    return result.fold(
      (failure) {
        debugPrint(
          '❌ [RecurringRequestsCubit] Reject failed: ${failure.message}',
        );
        emit(currentState.copyWith(clearProcessing: true));
        return false;
      },
      (success) {
        debugPrint('✅ [RecurringRequestsCubit] Rejected successfully');
        loadData(); // Reload to refresh lists
        return true;
      },
    );
  }

  /// Refresh data.
  Future<void> refresh() => loadData();
}
