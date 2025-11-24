import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Use case for creating a new admin account.
///
/// Creates a new field owner/admin account with:
/// - Auth user in Supabase Auth
/// - Profile entry with admin role
/// - Generated default password
/// - Invitation tracking entry
///
/// The admin must change their password on first login.
///
/// Usage:
/// ```dart
/// final useCase = CreateAdminAccountUseCase(repository);
/// final result = await useCase(
///   email: 'admin@field.com',
///   fullName: 'John Doe',
///   phone: '+201234567890',
/// );
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (invitation) => showSuccess('Admin created! Password: ${invitation.defaultPassword}'),
/// );
/// ```
class CreateAdminAccountUseCase {
  final SuperAdminRepository repository;

  CreateAdminAccountUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Parameters:
  /// - [email]: Admin email address (required)
  /// - [fullName]: Admin full name (required)
  /// - [phone]: Admin phone number (optional)
  /// - [defaultPassword]: Custom password (optional, auto-generated if null)
  ///
  /// Returns:
  /// - [Right(AdminInvitationEntity)]: Admin created with invitation details
  /// - [Left(Failure)]: Error occurred
  ///
  /// Validation:
  /// - Email must be valid format
  /// - Email must not already exist
  /// - Full name must not be empty
  /// - Phone must be valid format if provided
  Future<Either<Failure, AdminInvitationEntity>> call({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) async {
    // Input validation
    if (email.trim().isEmpty) {
      return Left(ValidationFailure('Email cannot be empty'));
    }

    if (fullName.trim().isEmpty) {
      return Left(ValidationFailure('Full name cannot be empty'));
    }

    // Email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return Left(ValidationFailure('Invalid email format'));
    }

    // Phone validation if provided
    if (phone != null && phone.trim().isNotEmpty) {
      // Basic phone validation (starts with +, has at least 10 digits)
      final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
      if (!phoneRegex.hasMatch(phone)) {
        return Left(ValidationFailure('Invalid phone number format'));
      }
    }

    // Call repository to create admin
    return await repository.createAdminAccount(
      email: email.trim(),
      fullName: fullName.trim(),
      phone: phone?.trim(),
      defaultPassword: defaultPassword,
    );
  }
}
