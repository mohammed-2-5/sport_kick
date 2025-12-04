import 'package:shared_preferences/shared_preferences.dart';
import 'package:spo_kick/core/errors/exceptions.dart';

/// Local data source for favorites using SharedPreferences.
///
/// Handles persistence of favorite field IDs to local storage.
abstract class FavoritesLocalDataSource {
  /// Get list of favorite field IDs from local storage.
  ///
  /// Returns list of field IDs, or empty list if none saved.
  /// Throws [CacheException] if unable to read from storage.
  Future<List<String>> getFavoriteFieldIds();

  /// Save list of favorite field IDs to local storage.
  ///
  /// [fieldIds] - The list of field IDs to save.
  ///
  /// Throws [CacheException] if unable to write to storage.
  Future<void> saveFavoriteFieldIds(List<String> fieldIds);

  /// Clear all favorites from local storage.
  ///
  /// Throws [CacheException] if unable to clear storage.
  Future<void> clearFavorites();
}

/// Implementation of [FavoritesLocalDataSource] using SharedPreferences.
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  /// SharedPreferences key for storing favorite field IDs.
  static const String _favoritesKey = 'favorite_fields';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getFavoriteFieldIds() async {
    try {
      final favorites = sharedPreferences.getStringList(_favoritesKey);
      return favorites ?? [];
    } catch (e) {
      throw CacheException(
        'Failed to load favorites from local storage: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveFavoriteFieldIds(List<String> fieldIds) async {
    try {
      final success = await sharedPreferences.setStringList(
        _favoritesKey,
        fieldIds,
      );

      if (!success) {
        throw const CacheException('Failed to save favorites to local storage');
      }
    } catch (e) {
      throw CacheException(
        'Failed to save favorites to local storage: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      final success = await sharedPreferences.remove(_favoritesKey);

      if (!success) {
        throw const CacheException(
          'Failed to clear favorites from local storage',
        );
      }
    } catch (e) {
      throw CacheException(
        'Failed to clear favorites from local storage: ${e.toString()}',
      );
    }
  }
}
