import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/sport_category_entity.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_remote_datasource_facade.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';

/// Implementation of super admin repository.
///
/// Handles error conversion from exceptions to failures
/// and delegates actual work to remote data source.
class SuperAdminRepositoryImpl implements SuperAdminRepository {
  final SuperAdminRemoteDataSource remoteDataSource;

  SuperAdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PlatformStatisticsEntity>>
  getPlatformStatistics() async {
    try {
      debugPrint('📊 [SuperAdminRepository] Getting platform statistics...');
      final statistics = await remoteDataSource.getPlatformStatistics();
      return Right(statistics);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, AdminInvitationEntity>> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) async {
    try {
      debugPrint('🔐 [SuperAdminRepository] Creating admin account...');
      final invitation = await remoteDataSource.createAdminAccount(
        email: email,
        fullName: fullName,
        phone: phone,
        defaultPassword: defaultPassword,
      );
      return Right(invitation);
    } on ConflictException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ConflictException: ${e.message}');
      return Left(ConflictFailure(e.message));
    } on ValidationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ValidationException: ${e.message}');
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllAdmins() async {
    try {
      debugPrint('👥 [SuperAdminRepository] Getting all admins...');
      final admins = await remoteDataSource.getAllAdmins();
      return Right(admins);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      debugPrint('👥 [SuperAdminRepository] Getting all users...');
      final users = await remoteDataSource.getAllUsers();
      return Right(users);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    try {
      debugPrint('🔗 [SuperAdminRepository] Assigning field to admin...');
      await remoteDataSource.assignFieldToAdmin(
        adminId: adminId,
        fieldId: fieldId,
        notes: notes,
      );
      return const Right(null);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getAllCities() async {
    try {
      debugPrint('🏙️ [SuperAdminRepository] Getting all cities...');
      final cities = await remoteDataSource.getAllCities();
      return Right(cities);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getActiveCities() async {
    try {
      debugPrint('🏙️ [SuperAdminRepository] Getting active cities...');
      final cities = await remoteDataSource.getActiveCities();
      return Right(cities);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CityEntity>> createCity({
    required String name,
    bool isActive = true,
  }) async {
    try {
      debugPrint('🏙️ [SuperAdminRepository] Creating city: $name');
      final city = await remoteDataSource.createCity(
        name: name,
        isActive: isActive,
      );
      return Right(city);
    } on ValidationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ValidationException: ${e.message}');
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, CityEntity>> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  }) async {
    try {
      debugPrint('🏙️ [SuperAdminRepository] Updating city: $cityId');
      final city = await remoteDataSource.updateCity(
        cityId: cityId,
        name: name,
        isActive: isActive,
      );
      return Right(city);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCity({
    required String cityId,
    required bool hardDelete,
  }) async {
    try {
      debugPrint(
        '🏙️ [SuperAdminRepository] ${hardDelete ? "Hard" : "Soft"} deleting city: $cityId',
      );
      await remoteDataSource.deleteCity(cityId: cityId, hardDelete: hardDelete);
      return const Right(null);
    } on ValidationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ValidationException: ${e.message}');
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateUser(String userId) async {
    try {
      debugPrint('🚫 [SuperAdminRepository] Deactivating user...');
      await remoteDataSource.deactivateUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> activateUser(String userId) async {
    try {
      debugPrint('✅ [SuperAdminRepository] Activating user...');
      await remoteDataSource.activateUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> resetAdminPassword({
    required String adminId,
  }) async {
    try {
      debugPrint('🔐 [SuperAdminRepository] Resetting admin password...');
      final newPassword = await remoteDataSource.resetAdminPassword(adminId);
      debugPrint('✅ [SuperAdminRepository] Password reset successfully');
      return Right(newPassword);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ValidationException: ${e.message}');
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
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
  }) async {
    try {
      debugPrint('⚽ [SuperAdminRepository] Creating field...');
      final field = await remoteDataSource.createField(
        ownerId: ownerId,
        sportCategoryId: sportCategoryId,
        name: name,
        description: description,
        address: address,
        city: city,
        latitude: latitude,
        longitude: longitude,
        pricePerHour: pricePerHour,
        currency: currency,
        surfaceType: surfaceType,
        capacity: capacity,
        isIndoor: isIndoor,
        images: images,
        videoUrl: videoUrl,
        facilities: facilities,
        paymentPhone: paymentPhone,
        paymentMethod: paymentMethod,
      );
      return Right(field);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ConflictException: ${e.message}');
      return Left(ConflictFailure(e.message));
    } on ValidationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ValidationException: ${e.message}');
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } on AuthenticationException catch (e) {
      debugPrint('❌ [SuperAdminRepository] AuthException: ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
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
  }) async {
    try {
      debugPrint('✏️ [SuperAdminRepository] Updating field...');
      final field = await remoteDataSource.updateField(
        fieldId: fieldId,
        name: name,
        address: address,
        description: description,
        pricePerHour: pricePerHour,
        latitude: latitude,
        longitude: longitude,
        ownerId: ownerId,
        sportCategoryId: sportCategoryId,
        surfaceType: surfaceType,
        isIndoor: isIndoor,
        isVerified: isVerified,
        isActive: isActive,
        facilities: facilities,
        paymentPhone: paymentPhone,
        paymentMethod: paymentMethod,
      );
      return Right(field);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteField({
    required String fieldId,
    required bool hardDelete,
  }) async {
    try {
      debugPrint(
        '🗑️ [SuperAdminRepository] Deleting field (hard=$hardDelete)...',
      );
      await remoteDataSource.deleteField(
        fieldId: fieldId,
        hardDelete: hardDelete,
      );
      return const Right(null);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyField({
    required String fieldId,
    required bool isVerified,
  }) async {
    try {
      debugPrint('✅ [SuperAdminRepository] Verifying field...');
      await remoteDataSource.verifyField(
        fieldId: fieldId,
        isVerified: isVerified,
      );
      return const Right(null);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  // ============================================================================
  // SPORT CATEGORIES MANAGEMENT
  // ============================================================================

  @override
  Future<Either<Failure, List<SportCategoryEntity>>>
  getAllSportCategories() async {
    try {
      debugPrint('📂 [SuperAdminRepository] Getting all sport categories...');
      final categories = await remoteDataSource.getAllSportCategories();
      return Right(categories);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, SportCategoryEntity>> createSportCategory({
    required String name,
    String? icon,
    String? description,
  }) async {
    try {
      debugPrint('➕ [SuperAdminRepository] Creating sport category: $name');
      final category = await remoteDataSource.createSportCategory(
        name: name,
        icon: icon,
        description: description,
      );
      return Right(category);
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, SportCategoryEntity>> updateSportCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  }) async {
    try {
      debugPrint('✏️ [SuperAdminRepository] Updating sport category...');
      final category = await remoteDataSource.updateSportCategory(
        categoryId: categoryId,
        name: name,
        icon: icon,
        description: description,
      );
      return Right(category);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSportCategory({
    required String categoryId,
  }) async {
    try {
      debugPrint('🗑️ [SuperAdminRepository] Deleting sport category...');
      await remoteDataSource.deleteSportCategory(categoryId: categoryId);
      return const Right(null);
    } on NotFoundException catch (e) {
      debugPrint('❌ [SuperAdminRepository] NotFoundException: ${e.message}');
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      debugPrint('❌ [SuperAdminRepository] ServerException: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [SuperAdminRepository] Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
