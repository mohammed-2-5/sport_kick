import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';

/// Settings Repository Implementation
///
/// Implements the settings repository using local data source.
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  const SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences(
    String userId,
  ) async {
    try {
      final preferences = await localDataSource.getCachedPreferences(userId);
      return Right(preferences);
    } on CacheException {
      // If no cached preferences, return defaults
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
    try {
      final model = UserPreferencesModel.fromEntity(preferences);
      await localDataSource.cachePreferences(model);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to update preferences: $e'));
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> resetToDefaults(
    String userId,
  ) async {
    try {
      final defaultPreferences = UserPreferencesModel(userId: userId);
      await localDataSource.cachePreferences(defaultPreferences);
      return Right(defaultPreferences);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to reset preferences: $e'));
    }
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
