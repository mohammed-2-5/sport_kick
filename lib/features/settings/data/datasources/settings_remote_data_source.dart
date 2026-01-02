import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';

/// Settings Remote Data Source Interface
///
/// Defines the contract for managing user preferences in Supabase.
abstract class SettingsRemoteDataSource {
  /// Get user preferences from Supabase.
  ///
  /// Returns the user preferences for the given user ID.
  /// Throws [ServerException] if the request fails.
  Future<UserPreferencesModel?> getPreferences(String userId);

  /// Get or create user preferences from Supabase.
  ///
  /// If preferences exist, returns them. Otherwise, creates default
  /// preferences and returns them.
  /// Throws [ServerException] if the request fails.
  Future<UserPreferencesModel> getOrCreatePreferences(String userId);

  /// Update user preferences in Supabase.
  ///
  /// Upserts the preferences (insert or update).
  /// Throws [ServerException] if the request fails.
  Future<UserPreferencesModel> updatePreferences(
    UserPreferencesModel preferences,
  );

  /// Delete user preferences from Supabase.
  ///
  /// Used when resetting to defaults (delete then recreate).
  /// Throws [ServerException] if the request fails.
  Future<void> deletePreferences(String userId);
}

/// Settings Remote Data Source Implementation
///
/// Handles user preferences CRUD operations with Supabase.
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  static const String _tableName = 'user_preferences';

  const SettingsRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  @override
  Future<UserPreferencesModel?> getPreferences(String userId) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserPreferencesModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[SettingsRemoteDataSource] Postgrest error: ${e.message}');
      throw ServerException('Failed to get preferences: ${e.message}');
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] Error getting preferences: $e');
      throw ServerException('Failed to get preferences: $e');
    }
  }

  @override
  Future<UserPreferencesModel> getOrCreatePreferences(String userId) async {
    try {
      // First try to get existing preferences
      final existing = await getPreferences(userId);
      if (existing != null) {
        return existing;
      }

      // If not found, create default preferences
      final defaultPrefs = UserPreferencesModel(userId: userId);
      return await updatePreferences(defaultPrefs);
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] Error get/create: $e');
      throw ServerException('Failed to get or create preferences: $e');
    }
  }

  @override
  Future<UserPreferencesModel> updatePreferences(
    UserPreferencesModel preferences,
  ) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .upsert(preferences.toJson())
          .select()
          .single();

      return UserPreferencesModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('[SettingsRemoteDataSource] Upsert error: ${e.message}');
      throw ServerException('Failed to update preferences: ${e.message}');
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] Error updating: $e');
      throw ServerException('Failed to update preferences: $e');
    }
  }

  @override
  Future<void> deletePreferences(String userId) async {
    try {
      await _supabaseClient.from(_tableName).delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      debugPrint('[SettingsRemoteDataSource] Delete error: ${e.message}');
      throw ServerException('Failed to delete preferences: ${e.message}');
    } catch (e) {
      debugPrint('[SettingsRemoteDataSource] Error deleting: $e');
      throw ServerException('Failed to delete preferences: $e');
    }
  }
}
