import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';

/// Remote data source for super admin field update/delete/verify operations.
///
/// Handles:
/// - Field updates
/// - Field deletion (soft and hard)
/// - Field verification
abstract class SuperAdminFieldOperationsDataSource {
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

/// Implementation of super admin field operations data source.
class SuperAdminFieldOperationsDataSourceImpl
    implements SuperAdminFieldOperationsDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminFieldOperationsDataSourceImpl({required this.supabaseClient});

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
  }) async {
    try {
      debugPrint('✏️ [FieldOperationsDataSource] Updating field: $fieldId');

      final Map<String, dynamic> updateData = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (address != null) updateData['address'] = address;
      if (description != null) updateData['description'] = description;
      if (pricePerHour != null) updateData['price_per_hour'] = pricePerHour;
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;
      if (ownerId != null) updateData['owner_id'] = ownerId;
      if (sportCategoryId != null) {
        updateData['sport_category_id'] = sportCategoryId;
      }
      if (surfaceType != null) updateData['surface_type'] = surfaceType;
      if (isIndoor != null) updateData['is_indoor'] = isIndoor;
      if (isVerified != null) updateData['is_verified'] = isVerified;
      if (isActive != null) updateData['is_active'] = isActive;
      if (facilities != null) updateData['amenities'] = facilities;
      if (paymentPhone != null) updateData['payment_phone'] = paymentPhone;
      if (paymentMethod != null) updateData['payment_method'] = paymentMethod;

      final response = await supabaseClient
          .from('fields')
          .update(updateData)
          .eq('id', fieldId)
          .select()
          .single();

      debugPrint('✅ [FieldOperationsDataSource] Field updated');
      return FieldModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ [FieldOperationsDataSource] PostgrestException: ${e.message}',
      );
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldOperationsDataSource] Exception: $e');
      throw ServerException('Failed to update field: $e');
    }
  }

  @override
  Future<void> deleteField({
    required String fieldId,
    required bool hardDelete,
  }) async {
    try {
      debugPrint(
        '🗑️ [FieldOperationsDataSource] Deleting field: $fieldId (hard=$hardDelete)',
      );

      if (hardDelete) {
        await supabaseClient.from('fields').delete().eq('id', fieldId);
        debugPrint('✅ Field permanently deleted');
      } else {
        await supabaseClient
            .from('fields')
            .update({
              'is_active': false,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', fieldId);
        debugPrint('✅ Field deactivated');
      }
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ [FieldOperationsDataSource] PostgrestException: ${e.message}',
      );
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldOperationsDataSource] Exception: $e');
      throw ServerException('Failed to delete field: $e');
    }
  }

  @override
  Future<void> verifyField({
    required String fieldId,
    required bool isVerified,
  }) async {
    try {
      debugPrint(
        '${isVerified ? '✅' : '❌'} [FieldOperationsDataSource] Verify field: $fieldId = $isVerified',
      );

      await supabaseClient
          .from('fields')
          .update({
            'is_verified': isVerified,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', fieldId);

      debugPrint('✅ Field verification updated');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ [FieldOperationsDataSource] PostgrestException: ${e.message}',
      );
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldOperationsDataSource] Exception: $e');
      throw ServerException('Failed to verify field: $e');
    }
  }
}
