import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/field_form_utils.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/models/field_creation_data.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/verify_field_usecase.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_active_cities_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/field_management/field_management_state.dart';
import 'package:spo_kick/features/super_admin/presentation/validators/field_form_validator.dart';

/// Cubit for field management operations.
///
/// Handles:
/// - Creating new fields (with validation)
/// - Assigning fields to admins
/// - Loading all fields
/// - Loading admins and cities for form dropdowns
class FieldManagementCubit extends Cubit<FieldManagementState> {
  final CreateFieldUseCase createFieldUseCase;
  final AssignFieldToAdminUseCase assignFieldToAdminUseCase;
  final GetAllFieldsUseCase getAllFieldsUseCase;
  final UpdateFieldUseCase updateFieldUseCase;
  final DeleteFieldUseCase deleteFieldUseCase;
  final VerifyFieldUseCase verifyFieldUseCase;
  final GetAllAdminsUseCase getAllAdminsUseCase;
  final GetActiveCitiesUseCase getActiveCitiesUseCase;

  FieldManagementCubit({
    required this.createFieldUseCase,
    required this.assignFieldToAdminUseCase,
    required this.getAllFieldsUseCase,
    required this.updateFieldUseCase,
    required this.deleteFieldUseCase,
    required this.verifyFieldUseCase,
    required this.getAllAdminsUseCase,
    required this.getActiveCitiesUseCase,
  }) : super(const FieldManagementInitial());

  /// Submit field creation with validation.
  ///
  /// Validates all data, transforms it, and creates the field.
  /// Returns null if validation passes, error message if fails.
  Future<void> submitFieldCreation(
    FieldCreationData data,
    Map<String, String> sportCategories,
  ) async {
    debugPrint('🔄 [FieldManagementCubit] Validating and creating field...');

    // Validate admin selection
    if (data.adminId == null || data.adminId!.isEmpty) {
      emit(
        const FieldManagementError(
          'Please select an admin to assign this field',
        ),
      );
      return;
    }

    // Validate city selection
    if (data.city == null || data.city!.isEmpty) {
      emit(const FieldManagementError('Please select a city'));
      return;
    }

    // Validate sport category selection
    if (data.sportCategory == null || data.sportCategory!.isEmpty) {
      emit(const FieldManagementError('Please select a sport category'));
      return;
    }

    // Validate and parse price
    final priceError = FieldFormValidator.validatePrice(data.priceText);
    if (priceError != null) {
      emit(FieldManagementError(priceError));
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
    debugPrint('🔄 [FieldManagementCubit] Assigning field to admin...');
    debugPrint('   Admin ID: $adminId');
    debugPrint('   Field ID: $fieldId');

    emit(const FieldManagementLoading(message: 'Assigning field...'));

    final result = await assignFieldToAdminUseCase(
      adminId: adminId,
      fieldId: fieldId,
      notes: notes,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [FieldManagementCubit] Error assigning field: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (_) {
        debugPrint('✅ [FieldManagementCubit] Field assigned successfully');
        emit(FieldAssigned(adminId: adminId, fieldId: fieldId));
      },
    );
  }

  /// Load all fields in the system.
  Future<void> loadAllFields() async {
    debugPrint('🔄 [FieldManagementCubit] Loading all fields...');
    emit(const FieldManagementLoading(message: 'Loading fields...'));

    final result = await getAllFieldsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [FieldManagementCubit] Error loading fields: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (fields) {
        debugPrint('✅ [FieldManagementCubit] Loaded ${fields.length} fields');
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
    debugPrint('🔄 [FieldManagementCubit] Creating field...');
    debugPrint('   Name: $name');
    debugPrint('   Owner ID: $ownerId');
    debugPrint('   City: $city');

    emit(const FieldManagementLoading(message: 'Creating field...'));

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
          '❌ [FieldManagementCubit] Error creating field: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (field) {
        debugPrint('✅ [FieldManagementCubit] Field created successfully!');
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
    debugPrint('🔄 [FieldManagementCubit] Updating field: $fieldId');
    emit(const FieldManagementLoading(message: 'Updating field...'));

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
          '❌ [FieldManagementCubit] Error updating field: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (updatedField) {
        debugPrint('✅ [FieldManagementCubit] Field updated successfully!');
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
      '🔄 [FieldManagementCubit] Deleting field: $fieldId (hard=$hardDelete)',
    );
    emit(
      FieldManagementLoading(
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
          '❌ [FieldManagementCubit] Error deleting field: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (_) {
        final message = hardDelete
            ? 'Field permanently deleted'
            : 'Field deactivated successfully';
        debugPrint('✅ [FieldManagementCubit] $message');
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
      '🔄 [FieldManagementCubit] ${isVerified ? 'Verifying' : 'Unverifying'} field: $fieldId',
    );
    emit(
      FieldManagementLoading(
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
          '❌ [FieldManagementCubit] Error verifying field: ${failure.message}',
        );
        emit(FieldManagementError(failure.message));
      },
      (_) {
        final message = isVerified
            ? 'Field verified successfully'
            : 'Verification removed';
        debugPrint('✅ [FieldManagementCubit] $message');
        emit(FieldVerified(fieldId: fieldId, isVerified: isVerified));
        loadAllFields();
      },
    );
  }

  /// Load admins and cities for field creation form.
  ///
  /// Loads both admin list and cities list for dropdown options.
  Future<void> loadFormData() async {
    debugPrint('🔄 [FieldManagementCubit] Loading form data...');
    emit(const FieldManagementLoading(message: 'Loading form data...'));

    // Load admins
    final adminsResult = await getAllAdminsUseCase();

    // Load cities
    final citiesResult = await getActiveCitiesUseCase();

    // Check for errors
    final adminsError = adminsResult.fold((l) => l, (_) => null);
    final citiesError = citiesResult.fold((l) => l, (_) => null);

    if (adminsError != null) {
      debugPrint(
        '❌ [FieldManagementCubit] Error loading admins: ${adminsError.message}',
      );
      emit(FieldManagementError(adminsError.message));
      return;
    }

    if (citiesError != null) {
      debugPrint(
        '❌ [FieldManagementCubit] Error loading cities: ${citiesError.message}',
      );
      emit(FieldManagementError(citiesError.message));
      return;
    }

    // Extract successful data
    final admins = adminsResult.fold((_) => <UserEntity>[], (r) => r);
    final cities = citiesResult.fold((_) => <CityEntity>[], (r) => r);

    debugPrint(
      '✅ [FieldManagementCubit] Loaded ${admins.length} admins and ${cities.length} cities',
    );
    emit(FormDataLoaded(admins: admins, cities: cities));
  }

  /// Reset to initial state.
  void reset() {
    emit(const FieldManagementInitial());
  }

  /// Initialize field form with existing field data.
  ///
  /// Converts field entity to form data for editing.
  void initializeFieldForm(FieldEntity field) {
    debugPrint('🔄 [FieldManagementCubit] Initializing form with field data');
    debugPrint('   Field: ${field.name}');

    final formData = FieldFormData(
      name: field.name,
      description: field.description ?? '',
      address: field.address,
      pricePerHour: field.pricePerHour.toString(),
      city: field.city,
      sportCategoryId: field.sportCategoryId,
      size: FieldFormUtils.mapCapacityToSize(
        field.capacity,
        defaultSize: FieldFormConstants.defaultSize,
      ),
      surface: field.surfaceType ?? FieldFormConstants.defaultSurface,
      isIndoor: field.isIndoor,
      facilities: List<String>.from(field.facilities),
      paymentPhone: null,
      paymentMethod: 'vodafone_cash',
      latitude: field.latitude,
      longitude: field.longitude,
    );

    emit(FieldFormInitialized(formData));
    debugPrint('✅ [FieldManagementCubit] Form initialized successfully');
  }

  /// Submit field update with validation.
  ///
  /// Validates form data and updates the field.
  Future<void> submitFieldUpdate({
    required String fieldId,
    required String name,
    required String address,
    required String description,
    required String priceText,
    required String size,
    required String surface,
    required bool isIndoor,
    required List<String> facilities,
    String? paymentPhone,
    required String paymentMethod,
    double? latitude,
    double? longitude,
    String? ownerId,
  }) async {
    debugPrint('🔄 [FieldManagementCubit] Submitting field update...');
    debugPrint('   Field ID: $fieldId');
    debugPrint('   Name: $name');

    // Validate price
    final priceError = FieldFormValidator.validatePrice(priceText);
    if (priceError != null) {
      debugPrint(
        '❌ [FieldManagementCubit] Price validation failed: $priceError',
      );
      emit(FieldManagementError(priceError));
      return;
    }

    final price = double.parse(priceText);

    // Update field
    await updateField(
      fieldId: fieldId,
      name: name,
      address: address,
      description: description.isEmpty ? null : description,
      pricePerHour: price,
      latitude: latitude,
      longitude: longitude,
      ownerId: ownerId,
      surfaceType: surface,
      isIndoor: isIndoor,
      facilities: facilities,
      paymentPhone: paymentPhone,
      paymentMethod: paymentMethod,
    );
  }
}
