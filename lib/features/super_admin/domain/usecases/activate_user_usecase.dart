import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for activating a user account.
///
/// Sets is_active = true for the user.
/// User will be able to login after this.
///
/// Example:
/// ```dart
/// final useCase = ActivateUserUseCase(repository);
/// final result = await useCase(userId: 'user-123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (_) => print('User activated successfully'),
/// );
/// ```
class ActivateUserUseCase {
  final SuperAdminRepository repository;

  ActivateUserUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Parameters:
  /// - [userId]: ID of the user to activate
  ///
  /// Returns:
  /// - [Right(void)]: User activated successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> call({required String userId}) async {
    return await repository.activateUser(userId);
  }
}
