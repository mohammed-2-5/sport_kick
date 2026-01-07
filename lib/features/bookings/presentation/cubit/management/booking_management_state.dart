import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// Base class for all booking management states.
sealed class BookingManagementState extends Equatable {
  const BookingManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class BookingManagementInitial extends BookingManagementState {
  const BookingManagementInitial();
}

/// Loading state.
class BookingManagementLoading extends BookingManagementState {
  final String message;

  const BookingManagementLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class BookingManagementError extends BookingManagementState {
  final String message;

  const BookingManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// User bookings loaded.
class BookingsLoaded extends BookingManagementState {
  final List<BookingEntity> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];

  /// Get upcoming bookings (includes pending and confirmed, excludes past).
  List<BookingEntity> get upcomingBookings => bookings
      .where(
        (b) =>
            (b.status == BookingStatus.pending ||
                b.status == BookingStatus.confirmed) &&
            !b.isPast,
      )
      .toList();

  /// Get booking history.
  List<BookingEntity> get historyBookings => bookings
      .where((b) => b.isPast || b.status == BookingStatus.canceled)
      .toList();

  /// Get pending bookings.
  List<BookingEntity> get pendingBookings =>
      bookings.where((b) => b.status == BookingStatus.pending).toList();

  /// Check if user has any bookings.
  bool get hasBookings => bookings.isNotEmpty;

  /// Check if user has upcoming bookings.
  bool get hasUpcomingBookings => upcomingBookings.isNotEmpty;
}

/// Single booking loaded.
class BookingDetailsLoaded extends BookingManagementState {
  final BookingEntity booking;

  const BookingDetailsLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Booking canceled successfully.
class BookingCanceled extends BookingManagementState {
  final BookingEntity booking;

  const BookingCanceled(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Empty state (no bookings).
class BookingsEmpty extends BookingManagementState {
  final String? message;

  const BookingsEmpty({this.message});

  @override
  List<Object?> get props => [message];
}
