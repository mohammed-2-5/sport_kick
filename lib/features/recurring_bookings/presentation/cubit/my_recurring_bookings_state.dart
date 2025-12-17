import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';

/// States for the my recurring bookings cubit.
sealed class MyRecurringBookingsState extends Equatable {
  const MyRecurringBookingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class MyRecurringBookingsInitial extends MyRecurringBookingsState {
  const MyRecurringBookingsInitial();
}

/// Loading state.
final class MyRecurringBookingsLoading extends MyRecurringBookingsState {
  const MyRecurringBookingsLoading();
}

/// Loaded state with recurring bookings.
final class MyRecurringBookingsLoaded extends MyRecurringBookingsState {
  final List<RecurringBookingEntity> bookings;
  final List<RecurringBookingEntity> activeBookings;
  final List<RecurringBookingEntity> pendingBookings;
  final List<RecurringBookingEntity> otherBookings;

  MyRecurringBookingsLoaded({required this.bookings})
    : activeBookings = bookings
          .where((b) => b.status == RecurringBookingStatus.active)
          .toList(),
      pendingBookings = bookings
          .where((b) => b.status == RecurringBookingStatus.pendingApproval)
          .toList(),
      otherBookings = bookings
          .where(
            (b) =>
                b.status == RecurringBookingStatus.canceled ||
                b.status == RecurringBookingStatus.rejected,
          )
          .toList();

  bool get isEmpty => bookings.isEmpty;
  bool get hasActive => activeBookings.isNotEmpty;
  bool get hasPending => pendingBookings.isNotEmpty;

  @override
  List<Object?> get props => [bookings];
}

/// Error state.
final class MyRecurringBookingsError extends MyRecurringBookingsState {
  final String message;

  const MyRecurringBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action in progress state (for cancel, etc.).
final class MyRecurringBookingsActionInProgress
    extends MyRecurringBookingsState {
  final List<RecurringBookingEntity> bookings;
  final String actionBookingId;

  const MyRecurringBookingsActionInProgress({
    required this.bookings,
    required this.actionBookingId,
  });

  @override
  List<Object?> get props => [bookings, actionBookingId];
}
