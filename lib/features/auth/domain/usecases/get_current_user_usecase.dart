import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting the currently logged-in user.
///
/// Handles the business logic for retrieving current user session.
class GetCurrentUserUseCase {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  /// Executes the get current user use case.
  ///
  /// Returns [UserEntity] if user is logged in, null if not logged in,
  /// or [Failure] on error.
  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
