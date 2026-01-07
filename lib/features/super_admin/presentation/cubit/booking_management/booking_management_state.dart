import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

/// Base state for booking management operations.
sealed class BookingManagementState extends Equatable {
  const BookingManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class BookingManagementInitial extends BookingManagementState {
  const BookingManagementInitial();
}

/// Loading state with optional message.
class BookingManagementLoading extends BookingManagementState {
  final String message;

  const BookingManagementLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class BookingManagementError extends BookingManagementState {
  final String message;

  const BookingManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// All bookings loaded successfully.
class AllBookingsLoaded extends BookingManagementState {
  final List<BookingEntity> bookings;

  const AllBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

/// Booking status updated successfully.
class BookingStatusUpdated extends BookingManagementState {
  final String bookingId;
  final String newStatus;

  const BookingStatusUpdated({
    required this.bookingId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [bookingId, newStatus];

  String get successMessage => 'Booking status updated to $newStatus';
}

/// Booking cancelled successfully.
class BookingCancelled extends BookingManagementState {
  final String bookingId;

  const BookingCancelled({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];

  String get successMessage => 'Booking cancelled successfully';
}
