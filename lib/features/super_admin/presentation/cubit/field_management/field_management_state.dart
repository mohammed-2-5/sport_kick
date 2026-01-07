import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';

/// Base state for field management operations.
sealed class FieldManagementState extends Equatable {
  const FieldManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class FieldManagementInitial extends FieldManagementState {
  const FieldManagementInitial();
}

/// Form data loaded successfully (admins and cities).
class FormDataLoaded extends FieldManagementState {
  final List<UserEntity> admins;
  final List<CityEntity> cities;

  const FormDataLoaded({required this.admins, required this.cities});

  @override
  List<Object?> get props => [admins, cities];
}

/// Loading state with optional message.
class FieldManagementLoading extends FieldManagementState {
  final String message;

  const FieldManagementLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class FieldManagementError extends FieldManagementState {
  final String message;

  const FieldManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// All fields loaded successfully.
class AllFieldsLoaded extends FieldManagementState {
  final List<FieldEntity> fields;

  const AllFieldsLoaded(this.fields);

  @override
  List<Object?> get props => [fields];
}

/// Field created successfully.
class FieldCreated extends FieldManagementState {
  final FieldEntity field;

  const FieldCreated(this.field);

  @override
  List<Object?> get props => [field];

  /// Get display message for success notification
  String get successMessage =>
      'Field created successfully!\n\nName: ${field.name}\nCity: ${field.city}\nPrice: ${field.formattedPrice}';
}

/// Field updated successfully.
class FieldUpdated extends FieldManagementState {
  final FieldEntity field;

  const FieldUpdated(this.field);

  @override
  List<Object?> get props => [field];

  String get successMessage => 'Field "${field.name}" updated successfully!';
}

/// Field deleted successfully.
class FieldDeleted extends FieldManagementState {
  final String fieldId;
  final bool wasHardDelete;

  const FieldDeleted({required this.fieldId, required this.wasHardDelete});

  @override
  List<Object?> get props => [fieldId, wasHardDelete];

  String get successMessage => wasHardDelete
      ? 'Field permanently deleted'
      : 'Field deactivated successfully';
}

/// Field verification status changed.
class FieldVerified extends FieldManagementState {
  final String fieldId;
  final bool isVerified;

  const FieldVerified({required this.fieldId, required this.isVerified});

  @override
  List<Object?> get props => [fieldId, isVerified];

  String get successMessage =>
      isVerified ? 'Field verified successfully' : 'Field verification removed';
}

/// Field assigned to admin successfully.
class FieldAssigned extends FieldManagementState {
  final String adminId;
  final String fieldId;

  const FieldAssigned({required this.adminId, required this.fieldId});

  @override
  List<Object?> get props => [adminId, fieldId];
}

/// Field form initialized with data.
class FieldFormInitialized extends FieldManagementState {
  final FieldFormData formData;

  const FieldFormInitialized(this.formData);

  @override
  List<Object?> get props => [formData];
}

/// Field form data holder.
class FieldFormData extends Equatable {
  final String name;
  final String description;
  final String address;
  final String pricePerHour;
  final String? city;
  final String? sportCategoryId;
  final String size;
  final String surface;
  final bool isIndoor;
  final List<String> facilities;
  final String? paymentPhone;
  final String paymentMethod;
  final double? latitude;
  final double? longitude;

  const FieldFormData({
    required this.name,
    required this.description,
    required this.address,
    required this.pricePerHour,
    this.city,
    this.sportCategoryId,
    required this.size,
    required this.surface,
    required this.isIndoor,
    required this.facilities,
    this.paymentPhone,
    required this.paymentMethod,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    address,
    pricePerHour,
    city,
    sportCategoryId,
    size,
    surface,
    isIndoor,
    facilities,
    paymentPhone,
    paymentMethod,
    latitude,
    longitude,
  ];
}
