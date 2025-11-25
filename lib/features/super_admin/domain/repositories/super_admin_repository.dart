import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Repository interface for super admin operations.
///
/// Defines contracts for super admin features including:
/// - Platform statistics
/// - Admin management (create, list)
/// - Field assignment
/// - User management
/// - City management
///
/// Follows Clean Architecture: Domain layer defines interface,
/// Data layer implements it.
abstract class SuperAdminRepository {
  /// Get platform-wide statistics for super admin dashboard.
  ///
  /// Returns:
  /// - [Right(PlatformStatisticsEntity)]: Statistics loaded successfully
  /// - [Left(Failure)]: Error occurred (network, server, etc.)
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.getPlatformStatistics();
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (stats) => print('Total Users: ${stats.totalUsers}'),
  /// );
  /// ```
  Future<Either<Failure, PlatformStatisticsEntity>> getPlatformStatistics();

  /// Create a new admin account.
  ///
  /// Creates auth user and profile entry with admin role.
  /// Generates default password that admin must change on first login.
  ///
  /// Parameters:
  /// - [email]: Admin email address
  /// - [fullName]: Admin full name
  /// - [phone]: Admin phone number (optional)
  /// - [defaultPassword]: Generated password (optional, auto-generated if null)
  ///
  /// Returns:
  /// - [Right(AdminInvitationEntity)]: Admin created successfully
  /// - [Left(Failure)]: Error occurred
  ///
  /// Errors:
  /// - [ValidationFailure]: Invalid email or password format
  /// - [ConflictFailure]: Email already exists
  /// - [ServerFailure]: Database error
  Future<Either<Failure, AdminInvitationEntity>> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  });

  /// Get list of all admin users.
  ///
  /// Returns all users with role 'admin' or 'super_admin'.
  ///
  /// Returns:
  /// - [Right(List<UserEntity>)]: List of admins
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<UserEntity>>> getAllAdmins();

  /// Get list of all regular users.
  ///
  /// Returns all users with role 'user'.
  ///
  /// Returns:
  /// - [Right(List<UserEntity>)]: List of users
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<UserEntity>>> getAllUsers();

  /// Assign a field to an admin.
  ///
  /// Updates field's owner_id and creates audit trail entry.
  ///
  /// Parameters:
  /// - [adminId]: ID of the admin to assign field to
  /// - [fieldId]: ID of the field to assign
  /// - [notes]: Optional notes about the assignment
  ///
  /// Returns:
  /// - [Right(void)]: Assignment successful
  /// - [Left(Failure)]: Error occurred
  ///
  /// Errors:
  /// - [NotFoundFailure]: Admin or field not found
  /// - [ValidationFailure]: Admin is not an admin role
  /// - [ServerFailure]: Database error
  Future<Either<Failure, void>> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  });

  /// Get list of all cities.
  ///
  /// Returns all cities (active and inactive).
  ///
  /// Returns:
  /// - [Right(List<CityEntity>)]: List of cities
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<CityEntity>>> getAllCities();

  /// Get list of active cities.
  ///
  /// Returns only cities where is_active = true.
  ///
  /// Returns:
  /// - [Right(List<CityEntity>)]: List of active cities
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<CityEntity>>> getActiveCities();

  /// Deactivate a user account.
  ///
  /// Sets is_active = false for the user.
  /// User won't be able to login after this.
  ///
  /// Parameters:
  /// - [userId]: ID of the user to deactivate
  ///
  /// Returns:
  /// - [Right(void)]: User deactivated
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> deactivateUser(String userId);

  /// Activate a user account.
  ///
  /// Sets is_active = true for the user.
  ///
  /// Parameters:
  /// - [userId]: ID of the user to activate
  ///
  /// Returns:
  /// - [Right(void)]: User activated
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> activateUser(String userId);

  /// Create a new field and assign it to an admin.
  ///
  /// Only super admin can create fields. This method:
  /// 1. Creates the field in the database
  /// 2. Sets the owner_id to the specified admin
  /// 3. Creates audit trail entry in admin_field_assignments
  ///
  /// Parameters:
  /// - [ownerId]: ID of the admin who will own this field
  /// - [sportCategoryId]: ID of the sport category
  /// - [name]: Field name
  /// - [address]: Full address
  /// - [city]: City name
  /// - [pricePerHour]: Hourly rental price
  /// - [description]: Detailed description (optional)
  /// - [latitude]: GPS latitude (optional)
  /// - [longitude]: GPS longitude (optional)
  /// - [currency]: Currency code (default: 'EGP')
  /// - [surfaceType]: Surface type (optional)
  /// - [capacity]: Number of players (optional)
  /// - [isIndoor]: Indoor flag (default: false)
  /// - [images]: List of image URLs (default: empty)
  /// - [videoUrl]: Video URL (optional)
  /// - [facilities]: List of facilities (default: empty)
  ///
  /// Returns:
  /// - [Right(FieldEntity)]: Field created successfully
  /// - [Left(Failure)]: Error occurred
  ///
  /// Errors:
  /// - [ValidationFailure]: Invalid input data
  /// - [NotFoundFailure]: Admin not found
  /// - [UnauthorizedFailure]: User is not super admin
  /// - [ServerFailure]: Database error
  Future<Either<Failure, FieldEntity>> createField({
    required String ownerId,
    required String sportCategoryId,
    required String name,
    required String address,
    required String city,
    required double pricePerHour,
    String? description,
    double? latitude,
    double? longitude,
    String currency = 'EGP',
    String? surfaceType,
    int? capacity,
    bool isIndoor = false,
    List<String> images = const [],
    String? videoUrl,
    List<String> facilities = const [],
  });
}
