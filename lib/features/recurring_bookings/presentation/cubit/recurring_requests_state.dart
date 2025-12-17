import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';

/// States for owner's recurring requests management.
sealed class RecurringRequestsState extends Equatable {
  const RecurringRequestsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class RecurringRequestsInitial extends RecurringRequestsState {
  const RecurringRequestsInitial();
}

/// Loading state.
final class RecurringRequestsLoading extends RecurringRequestsState {
  const RecurringRequestsLoading();
}

/// Loaded state with pending requests and active subscriptions.
final class RecurringRequestsLoaded extends RecurringRequestsState {
  final List<RecurringBookingEntity> pendingRequests;
  final List<RecurringBookingEntity> activeSubscriptions;
  final String? processingRequestId;

  const RecurringRequestsLoaded({
    required this.pendingRequests,
    required this.activeSubscriptions,
    this.processingRequestId,
  });

  bool get hasPendingRequests => pendingRequests.isNotEmpty;
  bool get hasActiveSubscriptions => activeSubscriptions.isNotEmpty;
  int get pendingCount => pendingRequests.length;
  int get activeCount => activeSubscriptions.length;

  bool isProcessing(String requestId) => processingRequestId == requestId;

  RecurringRequestsLoaded copyWith({
    List<RecurringBookingEntity>? pendingRequests,
    List<RecurringBookingEntity>? activeSubscriptions,
    String? processingRequestId,
    bool clearProcessing = false,
  }) {
    return RecurringRequestsLoaded(
      pendingRequests: pendingRequests ?? this.pendingRequests,
      activeSubscriptions: activeSubscriptions ?? this.activeSubscriptions,
      processingRequestId: clearProcessing
          ? null
          : (processingRequestId ?? this.processingRequestId),
    );
  }

  @override
  List<Object?> get props => [
    pendingRequests,
    activeSubscriptions,
    processingRequestId,
  ];
}

/// Error state.
final class RecurringRequestsError extends RecurringRequestsState {
  final String message;

  const RecurringRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}
