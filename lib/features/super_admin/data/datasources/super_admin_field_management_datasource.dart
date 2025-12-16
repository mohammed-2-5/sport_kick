import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';

/// Remote data source for super admin field management operations.
///
/// Handles:
/// - Field creation
/// - Field assignments to admins
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

/// Implementation of super admin field management data source.
class SuperAdminFieldManagementDataSourceImpl
    implements SuperAdminFieldManagementDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminFieldManagementDataSourceImpl({required this.supabaseClient});

  /// Get current user ID from Supabase auth.
  String get _currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const AuthenticationException('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    try {
      final currentUserId = _currentUserId;

      debugPrint('🔗 [FieldMgmtDataSource] Assigning field to admin...');
      debugPrint('   Admin ID: $adminId');
      debugPrint('   Field ID: $fieldId');

      // Step 1: Update field owner_id
      await supabaseClient
          .from('fields')
          .update({
            'owner_id': adminId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', fieldId);

      debugPrint('✅ Field owner updated');

      // Step 2: Create audit trail entry
      await supabaseClient.from('admin_field_assignments').insert({
        'admin_id': adminId,
        'field_id': fieldId,
        'assigned_by': currentUserId,
        if (notes != null) 'notes': notes,
      });

      debugPrint('✅ Audit trail created');
      debugPrint('🎉 [FieldMgmtDataSource] Field assigned successfully!');
    } on PostgrestException catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');

      if (e.code == 'PGRST116') {
        throw const NotFoundException('Admin or field not found');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] Exception: $e');
      throw ServerException('Failed to assign field: $e');
    }
  }

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
  }) async {
    try {
      final currentUserId = _currentUserId;

      debugPrint('⚽ [FieldMgmtDataSource] Creating field...');
      debugPrint('   Name: $name');
      debugPrint('   Owner ID: $ownerId');
      debugPrint('   City: $city');
      debugPrint('   Price: $pricePerHour $currency/hour');

      // Get sport_category_id - default to Football if not found
      String actualSportCategoryId = sportCategoryId;
      if (sportCategoryId == 'football-category-id') {
        final sportCategoryResponse = await supabaseClient
            .from('sport_categories')
            .select('id')
            .eq('name', 'Football')
            .maybeSingle();

        if (sportCategoryResponse != null) {
          actualSportCategoryId = sportCategoryResponse['id'] as String;
        }
      }

      // Get city_id from city name
      final cityResponse = await supabaseClient
          .from('cities')
          .select('id')
          .eq('name', city)
          .maybeSingle();

      if (cityResponse == null) {
        throw NotFoundException('City not found: $city');
      }

      final cityId = cityResponse['id'] as String;

      // Prepare field data
      final fieldData = {
        'owner_id': ownerId,
        'sport_category_id': actualSportCategoryId,
        'name': name,
        if (description != null) 'description': description,
        'address': address,
        'city_id': cityId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'price_per_hour': pricePerHour,
        'currency': currency,
        if (surfaceType != null) 'surface_type': surfaceType,
        if (capacity != null) 'size': _capacityToSize(capacity),
        'images': images,
        'amenities': facilities,
        'is_active': true,
        'payment_phone': paymentPhone ?? '01068700814',
        'payment_method': paymentMethod,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Step 1: Insert field into database
      final response = await supabaseClient
          .from('fields')
          .insert(fieldData)
          .select()
          .single();

      debugPrint('✅ Field created in database');

      // Patch the response to match FieldModel.fromJson expectations
      final Map<String, dynamic> modelData = Map.from(response);
      modelData['city'] = city; // Use the city name from arguments
      modelData['capacity'] = capacity; // Use capacity from arguments
      modelData['facilities'] =
          response['amenities']; // Map amenities to facilities

      final fieldModel = FieldModel.fromJson(modelData);

      // Step 2: Create audit trail entry in admin_field_assignments
      await supabaseClient.from('admin_field_assignments').insert({
        'admin_id': ownerId,
        'field_id': fieldModel.id,
        'assigned_by': currentUserId,
        'notes': 'Field created by super admin',
      });

      debugPrint('✅ Audit trail created');
      debugPrint('🎉 [FieldMgmtDataSource] Field created successfully!');
      debugPrint('   Field ID: ${fieldModel.id}');

      return fieldModel;
    } on PostgrestException catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');

      if (e.code == 'PGRST116' || e.code == '23503') {
        throw const NotFoundException('Admin or sport category not found');
      }

      if (e.code == '23505') {
        throw const ConflictException('Field with this name already exists');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] Exception: $e');
      throw ServerException('Failed to create field: $e');
    }
  }

  /// Convert capacity to size format (e.g., 10 -> "5-a-side")
  String _capacityToSize(int capacity) {
    if (capacity <= 10) return '5-a-side';
    if (capacity <= 14) return '7-a-side';
    return '11-a-side';
  }

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
      debugPrint('✏️ [FieldMgmtDataSource] Updating field: $fieldId');

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

      debugPrint('✅ [FieldMgmtDataSource] Field updated');
      return FieldModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] PostgrestException: ${e.message}');
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] Exception: $e');
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
        '🗑️ [FieldMgmtDataSource] Deleting field: $fieldId (hard=$hardDelete)',
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
      debugPrint('❌ [FieldMgmtDataSource] PostgrestException: ${e.message}');
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] Exception: $e');
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
        '${isVerified ? '✅' : '❌'} [FieldMgmtDataSource] Verify field: $fieldId = $isVerified',
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
      debugPrint('❌ [FieldMgmtDataSource] PostgrestException: ${e.message}');
      if (e.code == 'PGRST116') {
        throw NotFoundException('Field not found: $fieldId');
      }
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldMgmtDataSource] Exception: $e');
      throw ServerException('Failed to verify field: $e');
    }
  }
}
