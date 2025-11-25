import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException, AdminUserAttributes;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';
import 'package:spo_kick/features/super_admin/data/models/city_model.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_statistics_model.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'dart:math';

/// Remote data source for super admin operations using Supabase.
///
/// Handles all super admin API calls including:
/// - Platform statistics
/// - Admin management
/// - Field assignments
/// - User management
/// - City management
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
  });
}

/// Implementation of super admin remote data source.
class SuperAdminRemoteDataSourceImpl implements SuperAdminRemoteDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminRemoteDataSourceImpl({required this.supabaseClient});

  /// Get current user ID from Supabase auth.
  String get _currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw AuthenticationException('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<PlatformStatisticsModel> getPlatformStatistics() async {
    try {
      debugPrint('📊 [SuperAdminDataSource] Fetching platform statistics...');

      final response = await supabaseClient
          .from('platform_statistics')
          .select()
          .single();

      debugPrint('✅ [SuperAdminDataSource] Platform statistics loaded');
      debugPrint('   Total Users: ${response['total_users']}');
      debugPrint('   Total Admins: ${response['total_admins']}');
      debugPrint('   Active Fields: ${response['active_fields']}');
      debugPrint('   Total Bookings: ${response['total_bookings']}');
      debugPrint('   Total Revenue: ${response['total_revenue']}');

      return PlatformStatisticsModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to load platform statistics: $e');
    }
  }

  @override
  @override
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) async {
    try {
      final currentUserId = _currentUserId;

      debugPrint(
        '🔐 [SuperAdminDataSource] Creating admin account via Edge Function...',
      );
      debugPrint('   Email: $email');
      debugPrint('   Name: $fullName');
      debugPrint('   Created by: $currentUserId');

      final password = defaultPassword ?? _generateDefaultPassword();
      debugPrint('   Generated password (local): $password');

      final response = await supabaseClient.functions.invoke(
        'create-admin', // name of the Edge Function
        body: {
          'email': email,
          'fullName': fullName,
          'phone': phone,
          'defaultPassword': password,
          'createdBy': currentUserId,
        },
      );

      if (response.data == null) {
        debugPrint(
          '❌ [SuperAdminDataSource] Empty response from create-admin function',
        );
        throw ServerException(
          'Failed to create admin account (empty response)',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['error'] != null) {
        // Edge function has returned an error object
        final String message = data['error'].toString();
        debugPrint('❌ [SuperAdminDataSource] Edge function error: $message');

        // Optionally map some common errors to ConflictException, etc.
        if (message.toLowerCase().contains('already exists')) {
          throw ConflictException('Email already exists');
        }

        throw ServerException('Failed to create admin account: $message');
      }

      debugPrint(
        '🎉 [SuperAdminDataSource] Admin account created successfully via Edge Function',
      );

      // Map the received JSON to your model
      return AdminInvitationModel.fromJson(data);
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('already exists') ||
          e.toString().contains('already registered')) {
        debugPrint('❌ [SuperAdminDataSource] Email conflict: $e');
        throw ConflictException('Email already exists');
      }
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to create admin account: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllAdmins() async {
    try {
      debugPrint('👥 [SuperAdminDataSource] Fetching all admins...');

      final response = await supabaseClient
          .from('profiles')
          .select()
          .inFilter('role', ['admin', 'super_admin'])
          .order('created_at', ascending: false);

      final admins = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ [SuperAdminDataSource] Loaded ${admins.length} admins');
      return admins;
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to load admins: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      debugPrint('👥 [SuperAdminDataSource] Fetching all users...');

      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('role', 'user')
          .order('created_at', ascending: false);

      final users = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ [SuperAdminDataSource] Loaded ${users.length} users');
      return users;
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to load users: $e');
    }
  }

  @override
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  }) async {
    try {
      final currentUserId = _currentUserId;

      debugPrint('🔗 [SuperAdminDataSource] Assigning field to admin...');
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
      debugPrint('🎉 [SuperAdminDataSource] Field assigned successfully!');
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');

      if (e.code == 'PGRST116') {
        throw NotFoundException('Admin or field not found');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to assign field: $e');
    }
  }

  @override
  Future<List<CityModel>> getAllCities() async {
    try {
      debugPrint('🏙️ [SuperAdminDataSource] Fetching all cities...');

      final response = await supabaseClient
          .from('cities')
          .select('*, fields(count)')
          .order('name', ascending: true);

      final cities = (response as List).map((json) {
        final data = Map<String, dynamic>.from(json as Map);
        // Extract count from fields relation
        if (data['fields'] != null && (data['fields'] as List).isNotEmpty) {
          data['fields_count'] = (data['fields'] as List).first['count'];
        } else {
          data['fields_count'] = 0;
        }
        return CityModel.fromJson(data);
      }).toList();

      debugPrint('✅ [SuperAdminDataSource] Loaded ${cities.length} cities');
      return cities;
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to load cities: $e');
    }
  }

  @override
  Future<List<CityModel>> getActiveCities() async {
    try {
      debugPrint('🏙️ [SuperAdminDataSource] Fetching active cities...');

      final response = await supabaseClient
          .from('cities')
          .select('*, fields(count)')
          .eq('is_active', true)
          .order('name', ascending: true);

      final cities = (response as List).map((json) {
        final data = Map<String, dynamic>.from(json as Map);
        // Extract count from fields relation
        if (data['fields'] != null && (data['fields'] as List).isNotEmpty) {
          data['fields_count'] = (data['fields'] as List).first['count'];
        } else {
          data['fields_count'] = 0;
        }
        return CityModel.fromJson(data);
      }).toList();

      debugPrint(
        '✅ [SuperAdminDataSource] Loaded ${cities.length} active cities',
      );
      return cities;
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to load active cities: $e');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      debugPrint('🚫 [SuperAdminDataSource] Deactivating user: $userId');

      await supabaseClient
          .from('profiles')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('✅ User deactivated');
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to deactivate user: $e');
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      debugPrint('✅ [SuperAdminDataSource] Activating user: $userId');

      await supabaseClient
          .from('profiles')
          .update({
            'is_active': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('✅ User activated');
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to activate user: $e');
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

      debugPrint('⚽ [SuperAdminDataSource] Creating field...');
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
      debugPrint('🎉 [SuperAdminDataSource] Field created successfully!');
      debugPrint('   Field ID: ${fieldModel.id}');

      return fieldModel;
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');

      if (e.code == 'PGRST116' || e.code == '23503') {
        throw NotFoundException('Admin or sport category not found');
      }

      if (e.code == '23505') {
        throw ConflictException('Field with this name already exists');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [SuperAdminDataSource] Exception: $e');
      throw ServerException('Failed to create field: $e');
    }
  }

  /// Convert capacity to size format (e.g., 10 -> "5-a-side")
  String _capacityToSize(int capacity) {
    if (capacity <= 10) return '5-a-side';
    if (capacity <= 14) return '7-a-side';
    return '11-a-side';
  }

  /// Generate a secure default password for new admins.
  ///
  /// Format: FieldAdmin{Year}@{RandomNumber}
  /// Example: FieldAdmin2025@743
  String _generateDefaultPassword() {
    final year = DateTime.now().year;
    final random = Random().nextInt(900) + 100; // 3-digit random number
    return 'FieldAdmin$year@$random';
  }
}
