/// Abstract base class for all exceptions in the application.
///
/// Exceptions are thrown by the data layer when something goes wrong
/// during data fetching, caching, or external service communication.
///
/// They are caught and converted to [Failure] objects in the repository layer.
abstract class AppException implements Exception {
  /// Human-readable error message.
  final String message;

  /// Optional error code for logging/debugging.
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => code != null ? '[$code] $message' : message;
}

/// Exception thrown when a server/API operation fails.
///
/// Thrown by remote data sources when:
/// - HTTP request fails
/// - Response status code is not 2xx
/// - Response cannot be parsed
/// - Server is unreachable
///
/// Example:
/// ```dart
/// if (response.statusCode != 200) {
///   throw ServerException('Failed to fetch data', 'HTTP_${response.statusCode}');
/// }
/// ```
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred', super.code]);
}

/// Exception thrown when a local cache operation fails.
///
/// Thrown by local data sources when:
/// - Hive box cannot be opened
/// - Data cannot be read from cache
/// - Data cannot be written to cache
/// - Cache is corrupted
///
/// Example:
/// ```dart
/// try {
///   await box.put(key, value);
/// } catch (e) {
///   throw CacheException('Failed to cache data');
/// }
/// ```
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred', super.code]);
}

/// Exception thrown when there is no network connection.
///
/// Thrown before making network requests if connectivity check fails.
///
/// Example:
/// ```dart
/// if (!await networkInfo.isConnected) {
///   throw NetworkException();
/// }
/// ```
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection',
    super.code,
  ]);
}

/// Exception thrown during authentication operations.
///
/// Thrown by auth data source when:
/// - Credentials are invalid
/// - User doesn't exist
/// - Session has expired
/// - Token is invalid
///
/// Example:
/// ```dart
/// if (response.user == null) {
///   throw AuthException('Invalid credentials', 'INVALID_CREDENTIALS');
/// }
/// ```
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed', super.code]);
}

/// Exception thrown when input data is invalid.
///
/// Thrown when:
/// - Required fields are missing
/// - Data format is incorrect
/// - Constraints are violated
///
/// Example:
/// ```dart
/// if (email.isEmpty) {
///   throw ValidationException('Email is required', 'EMAIL_REQUIRED');
/// }
/// ```
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed', super.code]);
}

/// Exception thrown when user is not authenticated or lacks valid session.
///
/// Thrown when:
/// - User is not logged in
/// - Session has expired
/// - Auth token is invalid or missing
/// - Operation requires authentication
///
/// Example:
/// ```dart
/// if (supabase.auth.currentUser == null) {
///   throw AuthenticationException('User not authenticated');
/// }
/// ```
class AuthenticationException extends AppException {
  const AuthenticationException([
    super.message = 'Authentication required',
    super.code,
  ]);
}

/// Exception thrown when a resource conflict occurs.
///
/// Thrown when:
/// - Unique constraint is violated
/// - Resource already exists
/// - Concurrent modification detected
/// - Time slot is already booked
///
/// Example:
/// ```dart
/// if (existingBooking != null) {
///   throw ConflictException('Time slot already booked');
/// }
/// ```
class ConflictException extends AppException {
  const ConflictException([
    super.message = 'Resource conflict detected',
    super.code,
  ]);
}

/// Exception thrown when a database operation fails.
///
/// Thrown by data sources when:
/// - SQL query fails
/// - Constraint violation occurs
/// - Foreign key reference is invalid
/// - Unique constraint is violated
///
/// Example:
/// ```dart
/// try {
///   await supabase.from('bookings').insert(data);
/// } catch (e) {
///   throw DatabaseException('Failed to insert booking', 'INSERT_FAILED');
/// }
/// ```
class DatabaseException extends AppException {
  const DatabaseException([
    super.message = 'Database error occurred',
    super.code,
  ]);
}

/// Exception thrown when a requested resource is not found.
///
/// Thrown when:
/// - Entity doesn't exist in database
/// - API returns 404
/// - File not found
///
/// Example:
/// ```dart
/// if (response.isEmpty) {
///   throw NotFoundException('Field not found', 'FIELD_NOT_FOUND');
/// }
/// ```
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found', super.code]);
}

/// Exception thrown when user doesn't have required permissions.
///
/// Thrown when:
/// - Row Level Security policy blocks access
/// - User role is insufficient
/// - Token lacks required scopes
///
/// Example:
/// ```dart
/// if (user.role != 'admin') {
///   throw PermissionException('Admin access required', 'ADMIN_REQUIRED');
/// }
/// ```
class PermissionException extends AppException {
  const PermissionException([super.message = 'Permission denied', super.code]);
}

/// Exception thrown when an operation times out.
///
/// Thrown when:
/// - HTTP request exceeds timeout
/// - Database query takes too long
/// - External service doesn't respond
///
/// Example:
/// ```dart
/// try {
///   await dio.get(url).timeout(Duration(seconds: 30));
/// } on TimeoutException {
///   throw TimeoutException('Request timed out', 'TIMEOUT');
/// }
/// ```
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Operation timed out', super.code]);
}

/// Exception thrown when data format is unexpected.
///
/// Thrown when:
/// - JSON parsing fails
/// - Required field is missing in response
/// - Data type doesn't match expected type
///
/// Example:
/// ```dart
/// if (json['id'] == null) {
///   throw FormatException('Missing required field: id', 'MISSING_FIELD');
/// }
/// ```
class FormatException extends AppException {
  const FormatException([super.message = 'Invalid data format', super.code]);
}
