import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/super_admin/domain/models/field_creation_data.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/verify_field_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/validators/field_form_validator.dart';

/// Mixin for field management operations.
///
/// Handles:
/// - Creating new fields (with validation)
/// - Assigning fields to admins
/// - Loading all fields
mixin FieldManagementOperations on Cubit<SuperAdminState> {
  // Dependencies
  CreateFieldUseCase get createFieldUseCase;
  AssignFieldToAdminUseCase get assignFieldToAdminUseCase;
  GetAllFieldsUseCase get getAllFieldsUseCase;
  UpdateFieldUseCase get updateFieldUseCase;
  DeleteFieldUseCase get deleteFieldUseCase;
  VerifyFieldUseCase get verifyFieldUseCase;

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
      paymentPhone: data.paymentPhone,
      paymentMethod: data.paymentMethod,
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
    String? paymentPhone,
    String paymentMethod = 'vodafone_cash',
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
      paymentPhone: paymentPhone,
      paymentMethod: paymentMethod,
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

  /// Update an existing field.
  Future<void> updateField({
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
    debugPrint('🔄 [SuperAdminCubit] Updating field: $fieldId');
    emit(const SuperAdminLoading(message: 'Updating field...'));

    final result = await updateFieldUseCase(
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

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error updating field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (updatedField) {
        debugPrint('✅ [SuperAdminCubit] Field updated successfully!');
        emit(FieldUpdated(updatedField));
        loadAllFields();
      },
    );
  }

  /// Delete a field (soft or hard delete).
  Future<void> deleteField({
    required String fieldId,
    required bool hardDelete,
  }) async {
    debugPrint(
      '🔄 [SuperAdminCubit] Deleting field: $fieldId (hard=$hardDelete)',
    );
    emit(
      SuperAdminLoading(
        message: hardDelete
            ? 'Permanently deleting field...'
            : 'Deactivating field...',
      ),
    );

    final result = await deleteFieldUseCase(
      fieldId: fieldId,
      deleteType: hardDelete ? DeleteType.hard : DeleteType.soft,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error deleting field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        final message = hardDelete
            ? 'Field permanently deleted'
            : 'Field deactivated successfully';
        debugPrint('✅ [SuperAdminCubit] $message');
        emit(FieldDeleted(fieldId: fieldId, wasHardDelete: hardDelete));
        loadAllFields();
      },
    );
  }

  /// Verify or unverify a field.
  Future<void> verifyField({
    required String fieldId,
    required bool isVerified,
  }) async {
    debugPrint(
      '🔄 [SuperAdminCubit] ${isVerified ? 'Verifying' : 'Unverifying'} field: $fieldId',
    );
    emit(
      SuperAdminLoading(
        message: isVerified ? 'Verifying field...' : 'Removing verification...',
      ),
    );

    final result = await verifyFieldUseCase(
      fieldId: fieldId,
      isVerified: isVerified,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error verifying field: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (_) {
        final message = isVerified
            ? 'Field verified successfully'
            : 'Verification removed';
        debugPrint('✅ [SuperAdminCubit] $message');
        emit(FieldVerified(fieldId: fieldId, isVerified: isVerified));
        loadAllFields();
      },
    );
  }
}
