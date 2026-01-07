import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';

/// Base state for city management operations.
sealed class CityManagementState extends Equatable {
  const CityManagementState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class CityManagementInitial extends CityManagementState {
  const CityManagementInitial();
}

/// Loading state with optional message.
class CityManagementLoading extends CityManagementState {
  final String message;

  const CityManagementLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class CityManagementError extends CityManagementState {
  final String message;

  const CityManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

/// List of cities loaded.
class CitiesLoaded extends CityManagementState {
  final List<CityEntity> cities;

  const CitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

/// City created successfully.
class CityCreated extends CityManagementState {
  final CityEntity city;

  const CityCreated(this.city);

  @override
  List<Object?> get props => [city];

  String get successMessage => 'City "${city.name}" created successfully!';
}

/// City updated successfully.
class CityUpdated extends CityManagementState {
  final CityEntity city;

  const CityUpdated(this.city);

  @override
  List<Object?> get props => [city];

  String get successMessage => 'City "${city.name}" updated successfully!';
}

/// City deleted successfully.
class CityDeleted extends CityManagementState {
  final String cityId;
  final bool wasHardDelete;

  const CityDeleted({required this.cityId, required this.wasHardDelete});

  @override
  List<Object?> get props => [cityId, wasHardDelete];

  String get successMessage => wasHardDelete
      ? 'City permanently deleted'
      : 'City deactivated successfully';
}
