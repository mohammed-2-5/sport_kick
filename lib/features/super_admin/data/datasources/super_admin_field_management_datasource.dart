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
  });

  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  });
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
}
