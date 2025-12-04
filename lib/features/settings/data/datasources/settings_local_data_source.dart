import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';

/// Settings Local Data Source Interface
abstract class SettingsLocalDataSource {
  /// Get cached user preferences
  Future<UserPreferencesModel> getCachedPreferences(String userId);

  /// Cache user preferences
  Future<void> cachePreferences(UserPreferencesModel preferences);

  /// Clear cached preferences
  Future<void> clearCache();
}

/// Settings Local Data Source Implementation
///
/// Uses SharedPreferences to store user preferences locally.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _preferencesKey = 'user_preferences_';

  const SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserPreferencesModel> getCachedPreferences(String userId) async {
    try {
      final jsonString = sharedPreferences.getString('$_preferencesKey$userId');

      if (jsonString == null) {
        throw CacheException('No cached preferences found for user $userId');
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserPreferencesModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException('Failed to get cached preferences: $e');
    }
  }

  @override
  Future<void> cachePreferences(UserPreferencesModel preferences) async {
    try {
      final jsonString = json.encode(preferences.toJson());
      await sharedPreferences.setString(
        '$_preferencesKey${preferences.userId}',
        jsonString,
      );
    } catch (e) {
      throw CacheException('Failed to cache preferences: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(_preferencesKey)) {
          await sharedPreferences.remove(key);
        }
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
