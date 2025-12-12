import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/platform_settings_repository.dart';

/// Get Platform Settings Use Case
///
/// Retrieves platform-wide configuration settings.
class GetPlatformSettingsUseCase {
  final PlatformSettingsRepository _repository;

  GetPlatformSettingsUseCase(this._repository);

  Future<Either<Failure, PlatformSettingsEntity>> call() {
    return _repository.getPlatformSettings();
  }
}
