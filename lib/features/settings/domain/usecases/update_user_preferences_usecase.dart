import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';

/// Update User Preferences Use Case
///
/// Updates user preferences in the repository.
class UpdateUserPreferencesUseCase {
  final SettingsRepository repository;

  const UpdateUserPreferencesUseCase(this.repository);

  Future<Either<Failure, UserPreferencesEntity>> call(
    UserPreferencesEntity preferences,
  ) async {
    return await repository.updateUserPreferences(preferences);
  }
}
