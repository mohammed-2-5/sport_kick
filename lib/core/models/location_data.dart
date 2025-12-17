import 'package:equatable/equatable.dart';

/// Represents a geographical location with address and coordinates.
///
/// Used by [MapLocationPicker] to return selected location data.
/// Contains address string and latitude/longitude coordinates.
class LocationData extends Equatable {
  /// Human-readable address (e.g., "123 Main St, Cairo, Egypt")
  final String address;

  /// Latitude coordinate (-90 to 90)
  final double latitude;

  /// Longitude coordinate (-180 to 180)
  final double longitude;

  const LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  /// Creates a copy with optional new values.
  LocationData copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return LocationData(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Creates from JSON map.
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {'address': address, 'latitude': latitude, 'longitude': longitude};
  }

  /// Default location (Cairo, Egypt).
  static const LocationData defaultLocation = LocationData(
    address: 'Cairo, Egypt',
    latitude: 30.0444,
    longitude: 31.2357,
  );

  /// Checks if coordinates are valid.
  bool get isValid =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  /// Returns formatted coordinates string.
  String get coordinatesString =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  @override
  List<Object?> get props => [address, latitude, longitude];

  @override
  String toString() => 'LocationData($address, $coordinatesString)';
}
