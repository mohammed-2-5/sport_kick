import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging out the current user.
///
/// Handles the business logic for user logout.
class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  /// Executes the logout use case.
  ///
  /// Returns [void] on successful logout or [Failure] on error.
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
