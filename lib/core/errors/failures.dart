import 'package:equatable/equatable.dart';

/// Abstract base class for all failures in the application.
///
/// Failures represent errors that occur during business logic execution.
/// They are part of the domain layer and should not contain implementation details.
///
/// All failures extend [Equatable] for value comparison and testing.
abstract class Failure extends Equatable {
  /// Human-readable error message describing what went wrong.
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Failure that occurs when a server/API operation fails.
///
/// This includes:
/// - HTTP errors (4xx, 5xx status codes)
/// - API response parsing errors
/// - Server timeouts
///
/// Example:
/// ```dart
/// return Left(ServerFailure('Failed to fetch fields'));
/// ```
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

/// Failure that occurs when a local cache operation fails.
///
/// This includes:
/// - Hive database errors
/// - SharedPreferences errors
/// - Local storage read/write failures
///
/// Example:
/// ```dart
/// return Left(CacheFailure('Failed to cache user data'));
/// ```
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

/// Failure that occurs when there is no network connection.
///
/// This should be checked before making any network requests.
///
/// Example:
/// ```dart
/// if (!await networkInfo.isConnected) {
///   return Left(NetworkFailure());
/// }
/// ```
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
      : super(message);
}

/// Failure that occurs during authentication operations.
///
/// This includes:
/// - Invalid credentials
/// - Session expired
/// - Unauthorized access
/// - User not found
///
/// Example:
/// ```dart
/// return Left(AuthFailure('Invalid email or password'));
/// ```
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) : super(message);
}

/// Failure that occurs when input validation fails.
///
/// This includes:
/// - Invalid email format
/// - Weak password
/// - Missing required fields
/// - Invalid phone number
///
/// Example:
/// ```dart
/// return Left(ValidationFailure('Email format is invalid'));
/// ```
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed']) : super(message);
}

/// Failure that occurs when user is not authenticated.
///
/// This includes:
/// - User not logged in
/// - Session expired
/// - Invalid auth token
/// - Authentication required for operation
///
/// Example:
/// ```dart
/// return Left(AuthenticationFailure('Please log in to continue'));
/// ```
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication required'])
      : super(message);
}

/// Failure that occurs when a resource conflict is detected.
///
/// This includes:
/// - Unique constraint violations
/// - Resource already exists
/// - Time slot already booked
/// - Concurrent modification conflicts
///
/// Example:
/// ```dart
/// return Left(ConflictFailure('This time slot is already booked'));
/// ```
class ConflictFailure extends Failure {
  const ConflictFailure([String message = 'Resource conflict detected'])
      : super(message);
}

/// Failure that occurs when a database operation fails.
///
/// This includes:
/// - Supabase database errors
/// - SQL query errors
/// - Foreign key violations
/// - Unique constraint violations
///
/// Example:
/// ```dart
/// return Left(DatabaseFailure('Failed to create booking'));
/// ```
class DatabaseFailure extends Failure {
  const DatabaseFailure([String message = 'Database error occurred'])
      : super(message);
}

/// Failure that occurs when a resource is not found.
///
/// This includes:
/// - Field not found
/// - Booking not found
/// - User not found
///
/// Example:
/// ```dart
/// return Left(NotFoundFailure('Field not found'));
/// ```
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found']) : super(message);
}

/// Failure that occurs when a business rule is violated.
///
/// This includes:
/// - Time slot already booked
/// - Cannot cancel confirmed booking
/// - Booking date in the past
///
/// Example:
/// ```dart
/// return Left(BusinessRuleFailure('Cannot book a slot in the past'));
/// ```
class BusinessRuleFailure extends Failure {
  const BusinessRuleFailure([String message = 'Business rule violation'])
      : super(message);
}

/// Failure that occurs when user doesn't have permission.
///
/// This includes:
/// - Accessing another user's data
/// - Modifying protected resources
/// - Admin-only operations
///
/// Example:
/// ```dart
/// return Left(PermissionFailure('You do not have permission to perform this action'));
/// ```
class PermissionFailure extends Failure {
  const PermissionFailure(
      [String message = 'Permission denied'])
      : super(message);
}
