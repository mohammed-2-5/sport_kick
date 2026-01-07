import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

/// Base state for owner operations
sealed class OwnerState extends Equatable {
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

/// Combined data loaded state - holds all owner data
class OwnerDataLoaded extends OwnerState {
  final List<FieldEntity> fields;
  final List<BookingEntity> bookings;
  final OwnerRevenueEntity? revenue;

  const OwnerDataLoaded({
    this.fields = const [],
    this.bookings = const [],
    this.revenue,
  });

  OwnerDataLoaded copyWith({
    List<FieldEntity>? fields,
    List<BookingEntity>? bookings,
    OwnerRevenueEntity? revenue,
  }) {
    return OwnerDataLoaded(
      fields: fields ?? this.fields,
      bookings: bookings ?? this.bookings,
      revenue: revenue ?? this.revenue,
    );
  }

  @override
  List<Object?> get props => [fields, bookings, revenue];
}

/// Error state
class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);

  @override
  List<Object?> get props => [message];
}

/// @deprecated Use OwnerDataLoaded instead
/// Fields loaded successfully
class OwnerFieldsLoaded extends OwnerState {
  final List<FieldEntity> fields;

  const OwnerFieldsLoaded(this.fields);

  @override
  List<Object?> get props => [fields];
}

/// @deprecated Use OwnerDataLoaded instead
/// Bookings loaded successfully
class OwnerBookingsLoaded extends OwnerState {
  final List<BookingEntity> bookings;

  const OwnerBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

/// @deprecated Use OwnerDataLoaded instead
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
