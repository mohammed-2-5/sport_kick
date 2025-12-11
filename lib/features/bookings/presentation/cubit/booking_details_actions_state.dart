part of 'booking_details_actions_cubit.dart';

/// Base state for booking details actions.
sealed class BookingDetailsActionsState extends Equatable {
  const BookingDetailsActionsState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no action in progress.
final class BookingDetailsActionsInitial extends BookingDetailsActionsState {
  const BookingDetailsActionsInitial();
}

/// Loading state - action in progress.
final class BookingDetailsActionsLoading extends BookingDetailsActionsState {
  const BookingDetailsActionsLoading();
}

/// Cancel dialog is open.
final class BookingDetailsActionsCancelDialogOpen
    extends BookingDetailsActionsState {
  const BookingDetailsActionsCancelDialogOpen();
}

/// Error state.
final class BookingDetailsActionsError extends BookingDetailsActionsState {
  final String message;

  const BookingDetailsActionsError(this.message);

  @override
  List<Object?> get props => [message];
}
