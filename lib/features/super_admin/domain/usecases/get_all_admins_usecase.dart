import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for getting list of all admin users.
///
/// Retrieves all users with role 'admin' or 'super_admin'.
/// Used in super admin dashboard to manage field owners.
///
/// Usage:
/// ```dart
/// final useCase = GetAllAdminsUseCase(repository);
/// final result = await useCase();
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (admins) => displayAdminsList(admins),
/// );
/// ```
class GetAllAdminsUseCase {
  final SuperAdminRepository repository;

  GetAllAdminsUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns:
  /// - [Right(List<UserEntity>)]: List of admin users
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getAllAdmins();
  }
}
