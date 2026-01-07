import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/field_form_utils.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_state.dart';

/// Cubit for managing owner's fields CRUD operations.
///
/// Handles field listing, updating, and deletion operations for field owners.
class OwnerFieldsCrudCubit extends Cubit<OwnerFieldsCrudState> {
  final GetOwnerFieldsUseCase getOwnerFieldsUseCase;
  final UpdateFieldUseCase updateFieldUseCase;
  final DeleteFieldUseCase deleteFieldUseCase;

  OwnerFieldsCrudCubit({
    required this.getOwnerFieldsUseCase,
    required this.updateFieldUseCase,
    required this.deleteFieldUseCase,
  }) : super(const OwnerFieldsCrudInitial());

  /// Load all fields owned by the owner
  Future<void> loadOwnerFields(String ownerId) async {
    debugPrint('🔄 [OwnerFieldsCrudCubit] Loading fields for owner: $ownerId');
    emit(const OwnerFieldsCrudLoading(message: 'Loading your fields...'));

    final result = await getOwnerFieldsUseCase(ownerId: ownerId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerFieldsCrudCubit] Error loading fields: ${failure.message}',
        );
        emit(OwnerFieldsCrudError(failure.message));
      },
      (fields) {
        debugPrint('✅ [OwnerFieldsCrudCubit] Loaded ${fields.length} fields');
        emit(OwnerFieldsCrudLoaded(fields));
      },
    );
  }

  /// Update field details
  Future<void> updateField(String fieldId, Map<String, dynamic> updates) async {
    debugPrint('🔄 [OwnerFieldsCrudCubit] Updating field: $fieldId');
    emit(const OwnerFieldsCrudLoading(message: 'Updating field...'));

    final result = await updateFieldUseCase(fieldId: fieldId, updates: updates);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerFieldsCrudCubit] Error updating field: ${failure.message}',
        );
        emit(OwnerFieldsCrudError(failure.message));
      },
      (field) {
        debugPrint('✅ [OwnerFieldsCrudCubit] Field updated successfully');
        emit(FieldUpdated(field));
      },
    );
  }

  /// Delete a field
  Future<void> deleteField(String fieldId) async {
    debugPrint('🔄 [OwnerFieldsCrudCubit] Deleting field: $fieldId');
    emit(const OwnerFieldsCrudLoading(message: 'Deleting field...'));

    final result = await deleteFieldUseCase(fieldId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerFieldsCrudCubit] Error deleting field: ${failure.message}',
        );
        emit(OwnerFieldsCrudError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerFieldsCrudCubit] Field deleted successfully');
        emit(FieldDeleted(fieldId));
      },
    );
  }

  /// Initialize field form with existing field data (for edit mode).
  ///
  /// Processes the field entity and prepares form data with proper mappings:
  /// - Maps capacity to owner size format (5v5, 7v7, 11v11)
  /// - Validates surface type against allowed values
  /// - Converts isIndoor boolean to type string (Indoor/Outdoor)
  /// - Copies facilities list
  void initializeFieldForm(FieldEntity? field) {
    debugPrint('🔄 [OwnerFieldsCrudCubit] Initializing field form');

    if (field == null) {
      debugPrint(
        '⚠️ [OwnerFieldsCrudCubit] No field provided for initialization',
      );
      emit(const OwnerFieldsCrudInitial());
      return;
    }

    // Map field data to form data
    final formData = <String, dynamic>{
      'name': field.name,
      'description': field.description,
      'address': field.address,
      'city': field.city,
      'pricePerHour': field.pricePerHour.toString(),
      'size': FieldFormUtils.mapCapacityToOwnerSize(
        field.capacity,
        defaultSize: OwnerConstants.fieldSizes.first,
      ),
      'surface': FieldFormUtils.validateDropdownValue(
        field.surfaceType,
        OwnerConstants.surfaceTypes,
      ),
      'type': FieldFormUtils.validateDropdownValue(
        field.isIndoor ? 'Indoor' : 'Outdoor',
        OwnerConstants.fieldTypes,
      ),
      'facilities': List<String>.from(field.facilities),
    };

    debugPrint(
      '✅ [OwnerFieldsCrudCubit] Field form initialized with data: $formData',
    );
    emit(FieldFormInitialized(formData));
  }

  /// Submit field update with form data.
  ///
  /// Validates and processes form data before calling the update use case.
  /// Handles the entire update flow including loading and error states.
  Future<void> submitFieldUpdate(
    String fieldId,
    Map<String, dynamic> formData,
  ) async {
    debugPrint(
      '🔄 [OwnerFieldsCrudCubit] Submitting field update for: $fieldId',
    );
    debugPrint('📋 [OwnerFieldsCrudCubit] Form data: $formData');

    emit(const OwnerFieldsCrudLoading(message: 'Updating field...'));

    // Prepare updates for backend
    final updates = <String, dynamic>{
      'name': formData['name'],
      'description': formData['description'],
      'address': formData['address'],
      'city': formData['city'],
      'price_per_hour': double.parse(formData['pricePerHour'] as String),
      'size': formData['size'],
      'surface': formData['surface'],
      'type': formData['type'],
      'facilities': formData['facilities'],
    };

    final result = await updateFieldUseCase(fieldId: fieldId, updates: updates);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerFieldsCrudCubit] Error updating field: ${failure.message}',
        );
        emit(OwnerFieldsCrudError(failure.message));
      },
      (field) {
        debugPrint('✅ [OwnerFieldsCrudCubit] Field updated successfully');
        emit(FieldUpdated(field));
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [OwnerFieldsCrudCubit] Resetting state');
    emit(const OwnerFieldsCrudInitial());
  }
}
