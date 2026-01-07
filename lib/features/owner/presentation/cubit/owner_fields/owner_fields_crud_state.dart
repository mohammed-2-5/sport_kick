import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Base state for owner fields CRUD operations.
sealed class OwnerFieldsCrudState extends Equatable {
  const OwnerFieldsCrudState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OwnerFieldsCrudInitial extends OwnerFieldsCrudState {
  const OwnerFieldsCrudInitial();
}

/// Loading state with optional message
class OwnerFieldsCrudLoading extends OwnerFieldsCrudState {
  final String message;

  const OwnerFieldsCrudLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class OwnerFieldsCrudError extends OwnerFieldsCrudState {
  final String message;

  const OwnerFieldsCrudError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Fields loaded successfully
class OwnerFieldsCrudLoaded extends OwnerFieldsCrudState {
  final List<FieldEntity> fields;

  const OwnerFieldsCrudLoaded(this.fields);

  @override
  List<Object?> get props => [fields];
}

/// Field updated successfully
class FieldUpdated extends OwnerFieldsCrudState {
  final FieldEntity field;

  const FieldUpdated(this.field);

  @override
  List<Object?> get props => [field];
}

/// Field deleted successfully
class FieldDeleted extends OwnerFieldsCrudState {
  final String fieldId;

  const FieldDeleted(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

/// Field form initialized (for edit mode)
class FieldFormInitialized extends OwnerFieldsCrudState {
  final Map<String, dynamic> formData;

  const FieldFormInitialized(this.formData);

  @override
  List<Object?> get props => [formData];
}
