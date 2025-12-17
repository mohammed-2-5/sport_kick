import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:spo_kick/core/models/location_data.dart';

/// Service for geocoding operations using Nominatim (OpenStreetMap).
///
/// Provides free geocoding without API key:
/// - Forward geocoding: address → coordinates
/// - Reverse geocoding: coordinates → address
class NominatimGeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  static const String _userAgent = 'SportKickApp/1.0';

  /// Search for addresses matching the query.
  ///
  /// Returns list of [LocationData] matching the search query.
  /// Limited to 5 results by default.
  static Future<List<LocationData>> searchAddress(
    String query, {
    int limit = 5,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
        '$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&limit=$limit&addressdetails=1',
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent});

      if (response.statusCode != 200) {
        debugPrint('[Nominatim] Search failed: ${response.statusCode}');
        return [];
      }

      final List<dynamic> data = json.decode(response.body);

      return data.map((item) {
        return LocationData(
          address: item['display_name'] as String? ?? '',
          latitude: double.tryParse(item['lat']?.toString() ?? '') ?? 0.0,
          longitude: double.tryParse(item['lon']?.toString() ?? '') ?? 0.0,
        );
      }).toList();
    } catch (e) {
      debugPrint('[Nominatim] Search error: $e');
      return [];
    }
  }

  /// Get address from coordinates (reverse geocoding).
  ///
  /// Returns [LocationData] with address for given coordinates.
  static Future<LocationData?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1',
      );

      final response = await http.get(uri, headers: {'User-Agent': _userAgent});

      if (response.statusCode != 200) {
        debugPrint(
          '[Nominatim] Reverse geocode failed: ${response.statusCode}',
        );
        return null;
      }

      final data = json.decode(response.body);

      if (data['error'] != null) {
        debugPrint('[Nominatim] Reverse geocode error: ${data['error']}');
        return null;
      }

      return LocationData(
        address: data['display_name'] as String? ?? '',
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      debugPrint('[Nominatim] Reverse geocode error: $e');
      return null;
    }
  }
}
