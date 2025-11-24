import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for getting list of all regular users.
///
/// Retrieves all users with role 'user' (customers).
/// Used in super admin dashboard to view platform users.
///
/// Usage:
/// ```dart
/// final useCase = GetAllUsersUseCase(repository);
/// final result = await useCase();
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (users) => displayUsersList(users),
/// );
/// ```
class GetAllUsersUseCase {
  final SuperAdminRepository repository;

  GetAllUsersUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns:
  /// - [Right(List<UserEntity>)]: List of regular users
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getAllUsers();
  }
}
