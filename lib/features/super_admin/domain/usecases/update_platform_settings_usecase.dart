import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/platform_settings_repository.dart';

/// Update Platform Operating Hours Use Case
///
/// Updates the default operating hours for new fields.
class UpdatePlatformOperatingHoursUseCase {
  final PlatformSettingsRepository _repository;

  UpdatePlatformOperatingHoursUseCase(this._repository);

  Future<Either<Failure, void>> call(PlatformSettingsEntity settings) {
    return _repository.updateOperatingHours(settings);
  }
}

/// Update Enforce Operating Hours Use Case
///
/// Updates whether operating hours should be enforced.
class UpdateEnforceOperatingHoursUseCase {
  final PlatformSettingsRepository _repository;

  UpdateEnforceOperatingHoursUseCase(this._repository);

  Future<Either<Failure, void>> call(bool enforce) {
    return _repository.updateEnforceOperatingHours(enforce);
  }
}
