import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Repository interface for authentication operations.
///
/// This defines the contract that the data layer must implement.
/// It uses the Either type from dartz to handle success and failure cases.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  ///
  /// Returns [UserEntity] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  /// - [AuthFailure] if credentials are invalid
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  ///
  /// Returns [UserEntity] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  /// - [AuthFailure] if email already exists or validation fails
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  /// Logs out the current user.
  ///
  /// Returns [void] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  Future<Either<Failure, void>> logout();

  /// Gets the currently logged-in user.
  ///
  /// Returns [UserEntity] if user is logged in, null if not logged in,
  /// or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  /// - [CacheFailure] if local session data is corrupted
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Updates the current user's profile.
  ///
  /// Returns updated [UserEntity] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  /// - [AuthFailure] if user is not authenticated
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
    List<String>? preferredSports,
  });

  /// Sends a password reset email to the user.
  ///
  /// Returns [void] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [NetworkFailure] if there's no internet connection
  /// - [ServerFailure] if the server returns an error
  /// - [AuthFailure] if email doesn't exist
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Checks if user session is valid.
  ///
  /// Returns true if session is valid, false otherwise.
  Future<bool> isSessionValid();
}
