import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spo_kick/features/auth/data/models/login_activity_model.dart';
import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

/// Login Activity Data Source
///
/// Handles all login activity database operations with Supabase.
abstract class LoginActivityDataSource {
  /// Log a new login event.
  Future<void> logLoginActivity(LoginActivityModel activity);

  /// Get login activity for a user.
  Future<List<LoginActivityModel>> getLoginActivity(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  /// Get all login activity (for super admin).
  Future<List<LoginActivityModel>> getAllLoginActivity({
    int limit = 50,
    int offset = 0,
    String? statusFilter,
  });

  /// Delete login activity older than specified days.
  Future<void> deleteOldActivity(int daysOld);
}

/// Login Activity Remote Data Source Implementation
class LoginActivityRemoteDataSource implements LoginActivityDataSource {
  final SupabaseClient _client;

  LoginActivityRemoteDataSource(this._client);

  @override
  Future<void> logLoginActivity(LoginActivityModel activity) async {
    try {
      await _client.from('login_activity').insert(activity.toInsertJson());
      debugPrint('[LoginActivityDS] Login activity logged successfully');
    } catch (e) {
      debugPrint('[LoginActivityDS] Error logging activity: $e');
      rethrow;
    }
  }

  @override
  Future<List<LoginActivityModel>> getLoginActivity(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('login_activity')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      final currentSessionId = _getCurrentSessionId();

      return (response as List).map((json) {
        final model = LoginActivityModel.fromJson(json);
        // Mark current session
        if (currentSessionId != null && model.id == currentSessionId) {
          return LoginActivityModel(
            id: model.id,
            userId: model.userId,
            timestamp: model.timestamp,
            ipAddress: model.ipAddress,
            deviceType: model.deviceType,
            deviceName: model.deviceName,
            location: model.location,
            status: model.status,
            userAgent: model.userAgent,
            isCurrentSession: true,
          );
        }
        return model;
      }).toList();
    } catch (e) {
      debugPrint('[LoginActivityDS] Error getting activity: $e');
      rethrow;
    }
  }

  @override
  Future<List<LoginActivityModel>> getAllLoginActivity({
    int limit = 50,
    int offset = 0,
    String? statusFilter,
  }) async {
    try {
      final baseQuery = _client.from('login_activity').select();

      final filteredQuery = statusFilter != null
          ? baseQuery.eq('status', statusFilter)
          : baseQuery;

      final response = await filteredQuery
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => LoginActivityModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('[LoginActivityDS] Error getting all activity: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteOldActivity(int daysOld) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      await _client
          .from('login_activity')
          .delete()
          .lt('timestamp', cutoffDate.toIso8601String());
      debugPrint('[LoginActivityDS] Old activity deleted');
    } catch (e) {
      debugPrint('[LoginActivityDS] Error deleting old activity: $e');
      rethrow;
    }
  }

  String? _getCurrentSessionId() {
    // This would be stored when logging in
    return null;
  }

  /// Get device info for logging.
  static DeviceType getDeviceType() {
    if (kIsWeb) return DeviceType.web;
    if (Platform.isAndroid || Platform.isIOS) return DeviceType.mobile;
    return DeviceType.desktop;
  }

  /// Get device name.
  static String getDeviceName() {
    if (kIsWeb) return 'Web Browser';
    if (Platform.isAndroid) return 'Android Device';
    if (Platform.isIOS) return 'iOS Device';
    if (Platform.isWindows) return 'Windows PC';
    if (Platform.isMacOS) return 'Mac';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown Device';
  }
}
