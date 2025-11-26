import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

/// Base state for owner operations
abstract class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OwnerInitial extends OwnerState {
  const OwnerInitial();
}

/// Loading state with optional message
class OwnerLoading extends OwnerState {
  final String message;

  const OwnerLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Fields loaded successfully
class OwnerFieldsLoaded extends OwnerState {
  final List<FieldEntity> fields;

  const OwnerFieldsLoaded(this.fields);

  @override
  List<Object?> get props => [fields];
}

/// Bookings loaded successfully
class OwnerBookingsLoaded extends OwnerState {
  final List<BookingEntity> bookings;

  const OwnerBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

/// Revenue loaded successfully
class OwnerRevenueLoaded extends OwnerState {
  final OwnerRevenueEntity revenue;

  const OwnerRevenueLoaded(this.revenue);

  @override
  List<Object?> get props => [revenue];
}

/// Action completed successfully (approve, reject, update)
class OwnerActionSuccess extends OwnerState {
  final String message;

  const OwnerActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
