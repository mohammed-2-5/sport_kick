import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

/// Settings Repository Interface
///
/// Defines the contract for managing user preferences and settings.
abstract class SettingsRepository {
  /// Get user preferences by user ID
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  );

  /// Update user preferences
  Future<Either<Failure, UserPreferencesEntity>> updateUserPreferences(
    UserPreferencesEntity preferences,
  );

  /// Reset preferences to defaults
  Future<Either<Failure, UserPreferencesEntity>> resetToDefaults(String userId);

  /// Clear local cache (logout scenario)
  Future<Either<Failure, void>> clearCache();
}
