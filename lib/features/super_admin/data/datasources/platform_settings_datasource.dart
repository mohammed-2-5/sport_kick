import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_settings_model.dart';

/// Platform Settings Data Source
///
/// Handles all platform settings database operations with Supabase.
abstract class PlatformSettingsDataSource {
  /// Get platform settings.
  Future<PlatformSettingsModel> getPlatformSettings();

  /// Update operating hours.
  Future<void> updateOperatingHours(PlatformSettingsModel settings);

  /// Update enforce operating hours setting.
  Future<void> updateEnforceOperatingHours(bool enforce);
}

/// Platform Settings Remote Data Source Implementation
class PlatformSettingsRemoteDataSource implements PlatformSettingsDataSource {
  final SupabaseClient _client;

  PlatformSettingsRemoteDataSource(this._client);

  @override
  Future<PlatformSettingsModel> getPlatformSettings() async {
    try {
      final response = await _client
          .from('platform_settings')
          .select()
          .inFilter('setting_key', [
            'default_operating_hours',
            'enforce_operating_hours',
          ]);

      return PlatformSettingsModel.fromRecords(
        (response as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      debugPrint('[PlatformSettingsDS] Error getting settings: $e');
      // Return defaults if table doesn't exist or error occurs
      return PlatformSettingsModel.fromEntity(
        PlatformSettingsModel.fromRecords(const []),
      );
    }
  }

  @override
  Future<void> updateOperatingHours(PlatformSettingsModel settings) async {
    try {
      final userId = _client.auth.currentUser?.id;

      await _client.from('platform_settings').upsert({
        'setting_key': 'default_operating_hours',
        'setting_value': jsonEncode(settings.operatingHoursToJson()),
        'description': 'Default operating hours for new fields',
        'updated_at': DateTime.now().toIso8601String(),
        'updated_by': userId,
      }, onConflict: 'setting_key');

      debugPrint('[PlatformSettingsDS] Operating hours updated');
    } catch (e) {
      debugPrint('[PlatformSettingsDS] Error updating hours: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateEnforceOperatingHours(bool enforce) async {
    try {
      final userId = _client.auth.currentUser?.id;

      await _client.from('platform_settings').upsert({
        'setting_key': 'enforce_operating_hours',
        'setting_value': enforce,
        'description': 'Whether to enforce operating hours for all fields',
        'updated_at': DateTime.now().toIso8601String(),
        'updated_by': userId,
      }, onConflict: 'setting_key');

      debugPrint('[PlatformSettingsDS] Enforce hours updated: $enforce');
    } catch (e) {
      debugPrint('[PlatformSettingsDS] Error updating enforce: $e');
      rethrow;
    }
  }
}
