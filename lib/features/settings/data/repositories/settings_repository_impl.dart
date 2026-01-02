import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/core/network/network_info.dart';
import 'package:spo_kick/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:spo_kick/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';

/// Settings Repository Implementation
///
/// Implements the settings repository using remote and local data sources.
/// Strategy: Remote-first with local cache fallback.
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      return _getFromRemoteAndCache(userId);
    } else {
      return _getFromLocalCache(userId);
    }
  }

  /// Fetch preferences from remote, cache locally.
  Future<Either<Failure, UserPreferencesEntity>> _getFromRemoteAndCache(
    String userId,
  ) async {
    try {
      final preferences = await remoteDataSource.getOrCreatePreferences(userId);
      await localDataSource.cachePreferences(preferences);
      return Right(preferences);
    } on ServerException catch (e) {
      debugPrint('[SettingsRepository] Remote failed, trying cache: $e');
      return _getFromLocalCache(userId);
    } catch (e) {
      debugPrint('[SettingsRepository] Unexpected error: $e');
      return _getFromLocalCache(userId);
    }
  }

  /// Fetch preferences from local cache, or return defaults.
  Future<Either<Failure, UserPreferencesEntity>> _getFromLocalCache(
    String userId,
  ) async {
    try {
      final preferences = await localDataSource.getCachedPreferences(userId);
      return Right(preferences);
    } on CacheException {
      // No cached preferences, return defaults
      final defaultPreferences = UserPreferencesModel(userId: userId);
      await localDataSource.cachePreferences(defaultPreferences);
      return Right(defaultPreferences);
    } catch (e) {
      return Left(CacheFailure('Failed to get preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> updateUserPreferences(
    UserPreferencesEntity preferences,
  ) async {
    final model = UserPreferencesModel.fromEntity(preferences);

    // Always update local cache first (optimistic update)
    try {
      await localDataSource.cachePreferences(model);
    } on CacheException catch (e) {
      debugPrint('[SettingsRepository] Cache update failed: $e');
    }

    // Sync to remote if online
    if (await networkInfo.isConnected) {
      try {
        final updated = await remoteDataSource.updatePreferences(model);
        await localDataSource.cachePreferences(updated);
        return Right(updated);
      } on ServerException catch (e) {
        debugPrint('[SettingsRepository] Remote update failed: $e');
        // Return local model since it was already updated
        return Right(model);
      }
    }

    return Right(model);
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> resetToDefaults(
    String userId,
  ) async {
    final defaultPreferences = UserPreferencesModel(userId: userId);

    // Update local cache
    try {
      await localDataSource.cachePreferences(defaultPreferences);
    } on CacheException catch (e) {
      debugPrint('[SettingsRepository] Cache reset failed: $e');
    }

    // Reset on remote if online
    if (await networkInfo.isConnected) {
      try {
        // Delete existing and create new defaults
        await remoteDataSource.deletePreferences(userId);
        final created = await remoteDataSource.updatePreferences(
          defaultPreferences,
        );
        await localDataSource.cachePreferences(created);
        return Right(created);
      } on ServerException catch (e) {
        debugPrint('[SettingsRepository] Remote reset failed: $e');
        return Right(defaultPreferences);
      }
    }

    return Right(defaultPreferences);
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear cache: $e'));
    }
  }
}
