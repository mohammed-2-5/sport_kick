import 'package:flutter/foundation.dart';
import 'package:spo_kick/features/super_admin/domain/models/field_creation_data.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/validators/field_form_validator.dart';

/// Extension for field management operations.
///
/// Handles:
/// - Creating new fields (with validation)
/// - Assigning fields to admins
/// - Loading all fields
extension FieldManagementOperations on SuperAdminCubit {
  /// Submit field creation with validation.
  ///
  /// Validates all data, transforms it, and creates the field.
  /// Returns null if validation passes, error message if fails.
  Future<void> submitFieldCreation(
    FieldCreationData data,
    Map<String, String> sportCategories,
  ) async {
    debugPrint('🔄 [SuperAdminCubit] Validating and creating field...');

    // Validate admin selection
    if (data.adminId == null || data.adminId!.isEmpty) {
      emit(
        const SuperAdminError('Please select an admin to assign this field'),
      );
      return;
    }

    // Validate city selection
    if (data.city == null || data.city!.isEmpty) {
      emit(const SuperAdminError('Please select a city'));
      return;
    }

    // Validate sport category selection
    if (data.sportCategory == null || data.sportCategory!.isEmpty) {
      emit(const SuperAdminError('Please select a sport category'));
      return;
    }

    // Validate and parse price
    final priceError = FieldFormValidator.validatePrice(data.priceText);
    if (priceError != null) {
      emit(SuperAdminError(priceError));
      return;
    }

    final price = double.parse(data.priceText);

    // Get capacity and sport category ID
    final capacity = FieldFormConstants.getSizeCapacity(data.size);
    final sportCategoryId = sportCategories[data.sportCategory] ?? '';

    // All validation passed - create field
    await createField(
      ownerId: data.adminId!,
      sportCategoryId: sportCategoryId,
      name: data.name,
      description: data.description?.isEmpty == true ? null : data.description,
      address: data.address,
      city: data.city!,
      pricePerHour: price,
      surfaceType: data.surface,
      capacity: capacity,
      isIndoor: data.isIndoor,
      facilities: data.facilities,
    );
  }

  /// Assign a field to an admin.
  Future<void> assignField({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    debugPrint('🔄 [SuperAdminCubit] Assigning field to admin...');
    debugPrint('   Admin ID: $adminId');
    debugPrint('   Field ID: $fieldId');

    emit(const SuperAdminLoading(message: 'Assigning field...'));

    final result = await assignFieldToAdminUseCase(
      adminId: adminId,
      fieldId: fieldId,
      notes: notes,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error assigning field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        debugPrint('✅ [SuperAdminCubit] Field assigned successfully');
        emit(FieldAssigned(adminId: adminId, fieldId: fieldId));
      },
    );
  }

  /// Load all fields in the system.
  Future<void> loadAllFields() async {
    debugPrint('🔄 [SuperAdminCubit] Loading all fields...');
    emit(const SuperAdminLoading(message: 'Loading fields...'));

    final result = await getAllFieldsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading fields: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (fields) {
        debugPrint('✅ [SuperAdminCubit] Loaded ${fields.length} fields');
        emit(AllFieldsLoaded(fields));
      },
    );
  }

  /// Create a new field and assign it to an admin.
  ///
  /// Only super admin can create fields.
  Future<void> createField({
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
  }) async {
    debugPrint('🔄 [SuperAdminCubit] Creating field...');
    debugPrint('   Name: $name');
    debugPrint('   Owner ID: $ownerId');
    debugPrint('   City: $city');

    emit(const SuperAdminLoading(message: 'Creating field...'));

    final result = await createFieldUseCase(
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
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error creating field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (field) {
        debugPrint('✅ [SuperAdminCubit] Field created successfully!');
        debugPrint('   Field ID: ${field.id}');
        debugPrint('   Name: ${field.name}');
        emit(FieldCreated(field));
      },
    );
  }
}
