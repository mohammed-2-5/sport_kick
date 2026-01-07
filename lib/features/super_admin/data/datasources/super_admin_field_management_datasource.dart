import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_field_assignment_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_field_creation_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_field_operations_datasource.dart';

/// Remote data source for super admin field management operations.
///
/// This is a facade that delegates to specialized datasources:
/// - Field creation operations (create with full metadata)
/// - Field operations (update, delete, verify)
/// - Field assignment operations (assign to admin)
///
/// Handles:
/// - Field creation
/// - Field assignments to admins
/// - Field updates
/// - Field deletion
/// - Field verification
abstract class SuperAdminFieldManagementDataSource {
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

  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
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

  /// Delete a field (soft or hard delete).
  Future<void> deleteField({required String fieldId, required bool hardDelete});

  /// Verify or unverify a field.
  Future<void> verifyField({required String fieldId, required bool isVerified});
}

/// Facade implementation that delegates to specialized datasources.
class SuperAdminFieldManagementDataSourceImpl
    implements SuperAdminFieldManagementDataSource {
  final SuperAdminFieldCreationDataSource _creationDataSource;
  final SuperAdminFieldOperationsDataSource _operationsDataSource;
  final SuperAdminFieldAssignmentDataSource _assignmentDataSource;

  SuperAdminFieldManagementDataSourceImpl({
    required SuperAdminFieldCreationDataSource creationDataSource,
    required SuperAdminFieldOperationsDataSource operationsDataSource,
    required SuperAdminFieldAssignmentDataSource assignmentDataSource,
  }) : _creationDataSource = creationDataSource,
       _operationsDataSource = operationsDataSource,
       _assignmentDataSource = assignmentDataSource;

  // ==================== Field Creation Operations ====================

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
    return _creationDataSource.createField(
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

  // ==================== Field Assignment Operations ====================

  @override
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  }) {
    return _assignmentDataSource.assignFieldToAdmin(
      adminId: adminId,
      fieldId: fieldId,
      notes: notes,
    );
  }

  // ==================== Field Operations (Update/Delete/Verify) ====================

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
    return _operationsDataSource.updateField(
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
    return _operationsDataSource.deleteField(
      fieldId: fieldId,
      hardDelete: hardDelete,
    );
  }

  @override
  Future<void> verifyField({
    required String fieldId,
    required bool isVerified,
  }) {
    return _operationsDataSource.verifyField(
      fieldId: fieldId,
      isVerified: isVerified,
    );
  }
}
