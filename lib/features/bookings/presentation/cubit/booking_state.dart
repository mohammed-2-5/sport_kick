import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

import '../../domain/entities/booking_status.dart';

/// Base class for all booking states.
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class BookingInitial extends BookingState {
  const BookingInitial();
}

/// Loading state.
class BookingLoading extends BookingState {
  final String? message;

  const BookingLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Time slots loaded successfully.
class TimeSlotsLoaded extends BookingState {
  final List<TimeSlotEntity> timeSlots;
  final DateTime selectedDate;
  final String fieldId;
  final TimeSlotEntity? selectedSlot;

  const TimeSlotsLoaded({
    required this.timeSlots,
    required this.selectedDate,
    required this.fieldId,
    this.selectedSlot,
  });

  @override
  List<Object?> get props => [timeSlots, selectedDate, fieldId, selectedSlot];

  /// Check if there are available slots.
  bool get hasAvailableSlots => timeSlots.any((slot) => slot.isAvailable);

  /// Get available slots only.
  List<TimeSlotEntity> get availableSlots =>
      timeSlots.where((slot) => slot.isAvailable).toList();

  /// Group slots by period.
  Map<String, List<TimeSlotEntity>> get slotsByPeriod =>
      TimeSlotEntity.groupSlotsByPeriod(timeSlots);

  TimeSlotsLoaded copyWith({
    List<TimeSlotEntity>? timeSlots,
    DateTime? selectedDate,
    String? fieldId,
    TimeSlotEntity? selectedSlot,
  }) {
    return TimeSlotsLoaded(
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      fieldId: fieldId ?? this.fieldId,
      selectedSlot: selectedSlot ?? this.selectedSlot,
    );
  }
}

/// Booking created successfully.
class BookingCreated extends BookingState {
  final BookingEntity booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// User bookings loaded.
class BookingsLoaded extends BookingState {
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
class BookingDetailsLoaded extends BookingState {
  final BookingEntity booking;

  const BookingDetailsLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Booking canceled successfully.
class BookingCanceled extends BookingState {
  final BookingEntity booking;

  const BookingCanceled(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Empty state (no bookings).
class BookingsEmpty extends BookingState {
  final String? message;

  const BookingsEmpty({this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
