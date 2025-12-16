import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/fields/data/models/sport_category_model.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_city_management_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_field_management_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_sport_category_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_statistics_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_user_management_datasource.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';
import 'package:spo_kick/features/super_admin/data/models/city_model.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_statistics_model.dart';

/// Facade datasource that maintains backward compatibility with the original
/// SuperAdminRemoteDataSource interface by delegating to specialized datasources.
///
/// This implements the Facade pattern to provide a unified interface while
/// the implementation is split across multiple focused datasources:
/// - Statistics operations
/// - User management operations
/// - Field management operations
/// - City management operations
///
/// This allows the repository layer to remain unchanged while we improve
/// code organization and maintainability at the datasource layer.
abstract class SuperAdminRemoteDataSource {
  Future<PlatformStatisticsModel> getPlatformStatistics();
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  });
  Future<List<UserModel>> getAllAdmins();
  Future<List<UserModel>> getAllUsers();
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  });
  Future<List<CityModel>> getAllCities();
  Future<List<CityModel>> getActiveCities();

  /// City CRUD operations
  Future<CityModel> createCity({required String name, bool isActive = true});
  Future<CityModel> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  });
  Future<void> deleteCity({required String cityId, required bool hardDelete});

  Future<void> deactivateUser(String userId);
  Future<void> activateUser(String userId);
  Future<FieldModel> createField({
    required String ownerId,
    required String sportCategoryId,
    required String name,
    required String address,
    required String city,
    required double pricePerHour,
    String? description,
    double? latitude,
    double? longitude,
    String currency,
    String? surfaceType,
    int? capacity,
    bool isIndoor,
    List<String> images,
    String? videoUrl,
    List<String> facilities,
    String? paymentPhone,
    String paymentMethod,
  });

  /// Update an existing field.
  Future<FieldModel> updateField({
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
  Future<void> deleteField({required String fieldId, required bool hardDelete});

  /// Verify or unverify a field.
  Future<void> verifyField({required String fieldId, required bool isVerified});

  // ============================================================================
  // SPORT CATEGORIES
  // ============================================================================

  /// Get all sport categories.
  Future<List<SportCategoryModel>> getAllSportCategories();

  /// Create a new sport category.
  Future<SportCategoryModel> createSportCategory({
    required String name,
    String? icon,
    String? description,
  });

  /// Update an existing sport category.
  Future<SportCategoryModel> updateSportCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  });

  /// Delete a sport category.
  Future<void> deleteSportCategory({required String categoryId});
}

/// Implementation of the facade that delegates to specialized datasources.
class SuperAdminRemoteDataSourceFacade implements SuperAdminRemoteDataSource {
  final SuperAdminStatisticsDataSource _statisticsDataSource;
  final SuperAdminUserManagementDataSource _userManagementDataSource;
  final SuperAdminFieldManagementDataSource _fieldManagementDataSource;
  final SuperAdminCityManagementDataSource _cityManagementDataSource;
  final SuperAdminSportCategoryDatasource _sportCategoryDataSource;

  SuperAdminRemoteDataSourceFacade({
    required SuperAdminStatisticsDataSource statisticsDataSource,
    required SuperAdminUserManagementDataSource userManagementDataSource,
    required SuperAdminFieldManagementDataSource fieldManagementDataSource,
    required SuperAdminCityManagementDataSource cityManagementDataSource,
    required SuperAdminSportCategoryDatasource sportCategoryDataSource,
  }) : _statisticsDataSource = statisticsDataSource,
       _userManagementDataSource = userManagementDataSource,
       _fieldManagementDataSource = fieldManagementDataSource,
       _cityManagementDataSource = cityManagementDataSource,
       _sportCategoryDataSource = sportCategoryDataSource;

  // ==================== Statistics Operations ====================

  @override
  Future<PlatformStatisticsModel> getPlatformStatistics() {
    return _statisticsDataSource.getPlatformStatistics();
  }

  // ==================== User Management Operations ====================

  @override
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) {
    return _userManagementDataSource.createAdminAccount(
      email: email,
      fullName: fullName,
      phone: phone,
      defaultPassword: defaultPassword,
    );
  }

  @override
  Future<List<UserModel>> getAllAdmins() {
    return _userManagementDataSource.getAllAdmins();
  }

  @override
  Future<List<UserModel>> getAllUsers() {
    return _userManagementDataSource.getAllUsers();
  }

  @override
  Future<void> activateUser(String userId) {
    return _userManagementDataSource.activateUser(userId);
  }

  @override
  Future<void> deactivateUser(String userId) {
    return _userManagementDataSource.deactivateUser(userId);
  }

  // ==================== Field Management Operations ====================

  @override
  Future<FieldModel> createField({
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
  }) {
    return _fieldManagementDataSource.createField(
      ownerId: ownerId,
      sportCategoryId: sportCategoryId,
      name: name,
      address: address,
      city: city,
      pricePerHour: pricePerHour,
      description: description,
      latitude: latitude,
      longitude: longitude,
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
  }

  @override
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  }) {
    return _fieldManagementDataSource.assignFieldToAdmin(
      adminId: adminId,
      fieldId: fieldId,
      notes: notes,
    );
  }

  // ==================== City Management Operations ====================

  @override
  Future<List<CityModel>> getAllCities() {
    return _cityManagementDataSource.getAllCities();
  }

  @override
  Future<List<CityModel>> getActiveCities() {
    return _cityManagementDataSource.getActiveCities();
  }

  @override
  Future<CityModel> createCity({required String name, bool isActive = true}) {
    return _cityManagementDataSource.createCity(name: name, isActive: isActive);
  }

  @override
  Future<CityModel> updateCity({
    required String cityId,
    String? name,
    bool? isActive,
  }) {
    return _cityManagementDataSource.updateCity(
      cityId: cityId,
      name: name,
      isActive: isActive,
    );
  }

  @override
  Future<void> deleteCity({required String cityId, required bool hardDelete}) {
    return _cityManagementDataSource.deleteCity(
      cityId: cityId,
      hardDelete: hardDelete,
    );
  }

  // ==================== Field CRUD Operations ====================

  @override
  Future<FieldModel> updateField({
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
  }) {
    return _fieldManagementDataSource.updateField(
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
  }

  @override
  Future<void> deleteField({
    required String fieldId,
    required bool hardDelete,
  }) {
    return _fieldManagementDataSource.deleteField(
      fieldId: fieldId,
      hardDelete: hardDelete,
    );
  }

  @override
  Future<void> verifyField({
    required String fieldId,
    required bool isVerified,
  }) {
    return _fieldManagementDataSource.verifyField(
      fieldId: fieldId,
      isVerified: isVerified,
    );
  }

  // ==================== Sport Categories Operations ====================

  @override
  Future<List<SportCategoryModel>> getAllSportCategories() {
    return _sportCategoryDataSource.getAllSportCategories();
  }

  @override
  Future<SportCategoryModel> createSportCategory({
    required String name,
    String? icon,
    String? description,
  }) {
    return _sportCategoryDataSource.createSportCategory(
      name: name,
      icon: icon,
      description: description,
    );
  }

  @override
  Future<SportCategoryModel> updateSportCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? description,
  }) {
    return _sportCategoryDataSource.updateSportCategory(
      categoryId: categoryId,
      name: name,
      icon: icon,
      description: description,
    );
  }

  @override
  Future<void> deleteSportCategory({required String categoryId}) {
    return _sportCategoryDataSource.deleteSportCategory(categoryId: categoryId);
  }
}
