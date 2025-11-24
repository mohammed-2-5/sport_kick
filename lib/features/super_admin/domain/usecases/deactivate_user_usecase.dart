import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for deactivating a user account.
///
/// Sets is_active = false for the user.
/// User won't be able to login after this.
///
/// Example:
/// ```dart
/// final useCase = DeactivateUserUseCase(repository);
/// final result = await useCase(userId: 'user-123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (_) => print('User deactivated successfully'),
/// );
/// ```
class DeactivateUserUseCase {
  final SuperAdminRepository repository;

  DeactivateUserUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Parameters:
  /// - [userId]: ID of the user to deactivate
  ///
  /// Returns:
  /// - [Right(void)]: User deactivated successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> call({required String userId}) async {
    return await repository.deactivateUser(userId);
  }
}
