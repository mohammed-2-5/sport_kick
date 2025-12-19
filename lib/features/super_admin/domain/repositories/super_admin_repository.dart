import 'package:dartz/dartz.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';

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

  /// Create a new city.
  ///
  /// Parameters:
  /// - [name]: City name
  /// - [isActive]: Whether the city is active (default: true)
  ///
  /// Returns:
  /// - [Right(CityEntity)]: City created successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, CityEntity>> createCity({
    required String name,
    bool isActive = true,
  });

  /// Update an existing city.
  ///
  /// Parameters:
  /// - [cityId]: ID of the city to update
  /// - [name]: New city name (optional)
  /// - [isActive]: New active status (optional)
  ///
  /// Returns:
  /// - [Right(CityEntity)]: City updated successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, CityEntity>> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  });

  /// Delete a city.
  ///
  /// Parameters:
  /// - [cityId]: ID of the city to delete
  /// - [hardDelete]: If true, permanently deletes; if false, sets is_active to false
  ///
  /// Returns:
  /// - [Right(void)]: City deleted successfully
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> deleteCity({
    required String cityId,
    required bool hardDelete,
  });

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

  /// Reset an admin's password.
  ///
  /// Generates a new password for admins with @sportkick.com emails
  /// who cannot receive password reset emails.
  /// Sets password_changed = false to force password change on next login.
  ///
  /// Parameters:
  /// - [adminId]: ID of the admin whose password to reset
  ///
  /// Returns:
  /// - [Right(String)]: New password generated
  /// - [Left(Failure)]: Error occurred
  ///
  /// Errors:
  /// - [NotFoundFailure]: Admin not found
  /// - [ValidationFailure]: Admin is not an admin role or has real email
  /// - [ServerFailure]: Database/Edge Function error
  Future<Either<Failure, String>> resetAdminPassword({required String adminId});

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
    String? paymentPhone,
    String paymentMethod = 'vodafone_cash',
  });

  /// Update an existing field.
  ///
  /// Only specified (non-null) parameters are updated.
  ///
  /// Returns:
  /// - [Right(FieldEntity)]: Updated field
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, FieldEntity>> updateField({
    required String fieldId,
    String? name,
    String? address,
    String? description,
    double? pricePerHour,
    double? latitude,
    double? longitude,
    String? ownerId,
    String? sportCategoryId,
    String? surfaceType,
    bool? isIndoor,
    bool? isVerified,
    bool? isActive,
    List<String>? facilities,
    String? paymentPhone,
    String? paymentMethod,
  });

  /// Delete a field.
  ///
  /// Parameters:
  /// - [fieldId]: ID of the field to delete
  /// - [hardDelete]: If true, permanently deletes. If false, sets is_active = false.
  ///
  /// Returns:
  /// - [Right(void)]: Deletion successful
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> deleteField({
    required String fieldId,
    required bool hardDelete,
  });

  /// Verify or unverify a field.
  ///
  /// Verified fields show a badge and get higher visibility.
  ///
  /// Returns:
  /// - [Right(void)]: Status updated
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, void>> verifyField({
    required String fieldId,
    required bool isVerified,
  });

  // ============================================================================
  // SPORT CATEGORIES MANAGEMENT
  // ============================================================================

  /// Get all sport categories.
  ///
  /// Returns all categories regardless of active status.
  ///
  /// Returns:
  /// - [Right(List<SportCategoryEntity>)]: List of categories
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, List<SportCategoryEntity>>> getAllSportCategories();

  /// Create a new sport category.
  ///
  /// Parameters:
  /// - [name]: Category name (e.g., "Football", "Basketball")
  /// - [icon]: Optional icon identifier
  /// - [description]: Optional description
  ///
  /// Returns:
  /// - [Right(SportCategoryEntity)]: Created category
  /// - [Left(Failure)]: Error occurred (e.g., duplicate name)
  Future<Either<Failure, SportCategoryEntity>> createSportCategory({
    required String name,
    String? icon,
    String? description,
  });

  /// Update an existing sport category.
  ///
  /// Parameters:
  /// - [categoryId]: ID of category to update
  /// - [name]: Optional new name
  /// - [icon]: Optional new icon
  /// - [description]: Optional new description
  ///
  /// Returns:
  /// - [Right(SportCategoryEntity)]: Updated category
  /// - [Left(Failure)]: Error occurred
  Future<Either<Failure, SportCategoryEntity>> updateSportCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  });

  /// Delete a sport category.
  ///
  /// Parameters:
  /// - [categoryId]: ID of category to delete
  ///
  /// Returns:
  /// - [Right(void)]: Category deleted
  /// - [Left(Failure)]: Error occurred (e.g., category in use)
  Future<Either<Failure, void>> deleteSportCategory({
    required String categoryId,
  });
}
