import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/errors/exceptions.dart';

/// City Local Data Source Interface
abstract class CityLocalDataSource {
  /// Save selected city ID to local storage
  Future<void> saveSelectedCityId(String cityId);

  /// Get selected city ID from local storage
  Future<String?> getSelectedCityId();

  /// Clear selected city from local storage
  Future<void> clearSelectedCityId();
}

/// City Local Data Source Implementation
///
/// Handles storing and retrieving selected city using SharedPreferences.
class CityLocalDataSourceImpl implements CityLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _selectedCityKey = 'selected_city_id';

  const CityLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveSelectedCityId(String cityId) async {
    try {
      final success = await sharedPreferences.setString(
        _selectedCityKey,
        cityId,
      );
      if (!success) {
        throw const CacheException('Failed to save selected city');
      }
    } catch (e) {
      throw CacheException('Error saving selected city: ${e.toString()}');
    }
  }

  @override
  Future<String?> getSelectedCityId() async {
    try {
      return sharedPreferences.getString(_selectedCityKey);
    } catch (e) {
      throw CacheException('Error retrieving selected city: ${e.toString()}');
    }
  }

  @override
  Future<void> clearSelectedCityId() async {
    try {
      final success = await sharedPreferences.remove(_selectedCityKey);
      if (!success) {
        throw const CacheException('Failed to clear selected city');
      }
    } catch (e) {
      throw CacheException('Error clearing selected city: ${e.toString()}');
    }
  }
}
