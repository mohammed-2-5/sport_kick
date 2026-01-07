import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

/// Base state for owner bookings approval operations.
sealed class OwnerBookingsApprovalState extends Equatable {
  const OwnerBookingsApprovalState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OwnerBookingsApprovalInitial extends OwnerBookingsApprovalState {
  const OwnerBookingsApprovalInitial();
}

/// Loading state with optional message
class OwnerBookingsApprovalLoading extends OwnerBookingsApprovalState {
  final String message;

  const OwnerBookingsApprovalLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class OwnerBookingsApprovalError extends OwnerBookingsApprovalState {
  final String message;

  const OwnerBookingsApprovalError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Bookings loaded successfully
class OwnerBookingsLoaded extends OwnerBookingsApprovalState {
  final List<BookingEntity> bookings;

  const OwnerBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

/// Booking approved successfully
class BookingApproved extends OwnerBookingsApprovalState {
  final String bookingId;

  const BookingApproved(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

/// Booking rejected successfully
class BookingRejected extends OwnerBookingsApprovalState {
  final String bookingId;
  final String reason;

  const BookingRejected(this.bookingId, this.reason);

  @override
  List<Object?> get props => [bookingId, reason];
}
