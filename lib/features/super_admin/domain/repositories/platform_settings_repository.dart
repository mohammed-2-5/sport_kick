import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';

/// Platform Settings Repository Interface
///
/// Defines the contract for platform settings data operations.
abstract class PlatformSettingsRepository {
  /// Get platform settings.
  Future<Either<Failure, PlatformSettingsEntity>> getPlatformSettings();

  /// Update operating hours.
  Future<Either<Failure, void>> updateOperatingHours(
    PlatformSettingsEntity settings,
  );

  /// Update enforce operating hours setting.
  Future<Either<Failure, void>> updateEnforceOperatingHours(bool enforce);
}
