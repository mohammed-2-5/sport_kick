import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for resetting an admin's password.
///
/// Generates a new password for admins with @sportkick.com emails
/// who cannot receive password reset emails.
/// Sets password_changed = false to force password change on next login.
///
/// Example:
/// ```dart
/// final useCase = ResetAdminPasswordUseCase(repository);
/// final result = await useCase(adminId: 'admin-123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (newPassword) => print('New password: $newPassword'),
/// );
/// ```
class ResetAdminPasswordUseCase {
  final SuperAdminRepository repository;

  ResetAdminPasswordUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Parameters:
  /// - [adminId]: ID of the admin whose password to reset
  ///
  /// Returns:
  /// - [Right(String)]: New password generated
  /// - [Left(Failure)]: Error occurred (admin not found, validation error, etc.)
  Future<Either<Failure, String>> call({required String adminId}) async {
    // Input validation
    if (adminId.trim().isEmpty) {
      return const Left(ValidationFailure('Admin ID cannot be empty'));
    }

    return await repository.resetAdminPassword(adminId: adminId);
  }
}
