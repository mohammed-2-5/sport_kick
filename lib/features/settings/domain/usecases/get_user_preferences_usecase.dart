import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/domain/repositories/settings_repository.dart';

/// Get User Preferences Use Case
///
/// Retrieves user preferences from the repository.
class GetUserPreferencesUseCase {
  final SettingsRepository repository;

  const GetUserPreferencesUseCase(this.repository);

  Future<Either<Failure, UserPreferencesEntity>> call(String userId) async {
    return await repository.getUserPreferences(userId);
  }
}
