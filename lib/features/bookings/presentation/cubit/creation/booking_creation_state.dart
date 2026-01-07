import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';

/// Base class for all booking creation states.
sealed class BookingCreationState extends Equatable {
  const BookingCreationState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class BookingCreationInitial extends BookingCreationState {
  const BookingCreationInitial();
}

/// Loading state.
class BookingCreationLoading extends BookingCreationState {
  final String message;

  const BookingCreationLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class BookingCreationError extends BookingCreationState {
  final String message;

  const BookingCreationError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Booking created successfully.
class BookingCreated extends BookingCreationState {
  final BookingEntity booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}
