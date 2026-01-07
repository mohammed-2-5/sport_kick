import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';

/// Base state for business hours feature.
sealed class BusinessHoursState extends Equatable {
  const BusinessHoursState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any operations.
class BusinessHoursInitial extends BusinessHoursState {
  const BusinessHoursInitial();
}

/// State when loading business hours.
class BusinessHoursLoading extends BusinessHoursState {
  const BusinessHoursLoading();
}

/// State when business hours are successfully loaded.
class BusinessHoursLoaded extends BusinessHoursState {
  /// List of business hours for all 7 days
  final List<BusinessHoursEntity> businessHours;

  /// Whether the field is currently open
  final bool? isCurrentlyOpen;

  const BusinessHoursLoaded({
    required this.businessHours,
    this.isCurrentlyOpen,
  });

  @override
  List<Object?> get props => [businessHours, isCurrentlyOpen];

  /// Creates a copy with updated fields
  BusinessHoursLoaded copyWith({
    List<BusinessHoursEntity>? businessHours,
    bool? isCurrentlyOpen,
  }) {
    return BusinessHoursLoaded(
      businessHours: businessHours ?? this.businessHours,
      isCurrentlyOpen: isCurrentlyOpen ?? this.isCurrentlyOpen,
    );
  }
}

/// State when business hours are being updated.
class BusinessHoursUpdating extends BusinessHoursState {
  /// Previous business hours to allow UI to show optimistic updates
  final List<BusinessHoursEntity> businessHours;

  const BusinessHoursUpdating(this.businessHours);

  @override
  List<Object?> get props => [businessHours];
}

/// State when business hours are successfully updated.
class BusinessHoursUpdated extends BusinessHoursState {
  /// Updated business hours
  final List<BusinessHoursEntity> businessHours;

  /// Success message to display
  final String? message;

  const BusinessHoursUpdated({required this.businessHours, this.message});

  @override
  List<Object?> get props => [businessHours, message];
}

/// State when default hours are being initialized.
class BusinessHoursInitializing extends BusinessHoursState {
  const BusinessHoursInitializing();
}

/// State when default hours are successfully initialized.
class BusinessHoursInitialized extends BusinessHoursState {
  /// Newly initialized business hours
  final List<BusinessHoursEntity> businessHours;

  const BusinessHoursInitialized(this.businessHours);

  @override
  List<Object?> get props => [businessHours];
}

/// State when validating a booking time.
class BusinessHoursValidating extends BusinessHoursState {
  const BusinessHoursValidating();
}

/// State when booking time validation completes.
class BusinessHoursValidated extends BusinessHoursState {
  /// Whether the booking time is valid
  final bool isValid;

  /// Optional message explaining validation result
  final String? message;

  const BusinessHoursValidated({required this.isValid, this.message});

  @override
  List<Object?> get props => [isValid, message];
}

/// State when an error occurs.
class BusinessHoursError extends BusinessHoursState {
  /// Error message to display
  final String message;

  /// Previous business hours if available (for error recovery)
  final List<BusinessHoursEntity>? businessHours;

  const BusinessHoursError({required this.message, this.businessHours});

  @override
  List<Object?> get props => [message, businessHours];
}
