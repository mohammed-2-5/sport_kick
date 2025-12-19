import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';

/// City State Base
abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class CityInitial extends CityState {
  const CityInitial();
}

/// Loading Cities
class CitiesLoading extends CityState {
  const CitiesLoading();
}

/// Cities Loaded Successfully
class CitiesLoaded extends CityState {
  final List<CityEntity> cities;
  final String? selectedCityId;

  const CitiesLoaded({required this.cities, this.selectedCityId});

  @override
  List<Object?> get props => [cities, selectedCityId];

  CitiesLoaded copyWith({List<CityEntity>? cities, String? selectedCityId}) {
    return CitiesLoaded(
      cities: cities ?? this.cities,
      selectedCityId: selectedCityId ?? this.selectedCityId,
    );
  }
}

/// City Selected
class CitySelected extends CityState {
  final CityEntity city;

  const CitySelected(this.city);

  @override
  List<Object?> get props => [city];
}

/// Saving City Selection
class CitySaving extends CityState {
  final CityEntity city;

  const CitySaving(this.city);

  @override
  List<Object?> get props => [city];
}

/// City Saved Successfully
class CitySaved extends CityState {
  final CityEntity city;
  final String? message;

  const CitySaved({required this.city, this.message});

  @override
  List<Object?> get props => [city, message];
}

/// Error State
class CityError extends CityState {
  final String message;

  const CityError(this.message);

  @override
  List<Object?> get props => [message];
}
