import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';

/// Reset Preferences Use Case
///
/// Resets user preferences to default values.
class ResetPreferencesUseCase {
  final SettingsRepository repository;

  const ResetPreferencesUseCase(this.repository);

  Future<Either<Failure, UserPreferencesEntity>> call(String userId) async {
    return await repository.resetToDefaults(userId);
  }
}
