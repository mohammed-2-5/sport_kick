import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/data/datasources/platform_settings_datasource.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_settings_model.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/platform_settings_repository.dart';

/// Platform Settings Repository Implementation
class PlatformSettingsRepositoryImpl implements PlatformSettingsRepository {
  final PlatformSettingsDataSource _dataSource;

  PlatformSettingsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, PlatformSettingsEntity>> getPlatformSettings() async {
    try {
      final settings = await _dataSource.getPlatformSettings();
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure('Failed to get platform settings: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOperatingHours(
    PlatformSettingsEntity settings,
  ) async {
    try {
      final model = PlatformSettingsModel.fromEntity(settings);
      await _dataSource.updateOperatingHours(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update operating hours: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEnforceOperatingHours(
    bool enforce,
  ) async {
    try {
      await _dataSource.updateEnforceOperatingHours(enforce);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update enforce setting: $e'));
    }
  }
}
