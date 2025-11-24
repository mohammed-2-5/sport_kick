import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException, AdminUserAttributes;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';
import 'package:spo_kick/features/super_admin/data/models/city_model.dart';
import 'package:spo_kick/features/super_admin/data/models/platform_statistics_model.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';
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
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) async {
    try {
      final currentUserId = _currentUserId;

      debugPrint('🔐 [SuperAdminDataSource] Creating admin account...');
      debugPrint('   Email: $email');
      debugPrint('   Name: $fullName');
      debugPrint('   Created by: $currentUserId');

      // Generate default password if not provided
      final password = defaultPassword ?? _generateDefaultPassword();
      debugPrint('   Generated password: $password');

      // Step 1: Create auth user
      debugPrint('📝 Step 1: Creating auth user...');
      final authResponse = await supabaseClient.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true, // Auto-confirm email
        ),
      );

      if (authResponse.user == null) {
        throw ServerException('Failed to create auth user');
      }

      final userId = authResponse.user!.id;
      debugPrint('✅ Auth user created: $userId');

      // Step 2: Create profile entry
      debugPrint('📝 Step 2: Creating profile entry...');
      await supabaseClient.from('profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        if (phone != null) 'phone': phone,
        'role': 'admin',
        'is_active': true,
        'password_changed': false, // Admin must change password on first login
      });

      debugPrint('✅ Profile created');

      // Step 3: Create invitation record
      debugPrint('📝 Step 3: Creating invitation record...');
      final invitationResponse = await supabaseClient
          .from('admin_invitations')
          .insert({
            'email': email,
            'default_password': password, // Store for display
            'full_name': fullName,
            if (phone != null) 'phone': phone,
            'created_by': currentUserId,
            'admin_id': userId,
            'status': 'pending',
          })
          .select()
          .single();

      debugPrint('✅ Invitation record created');
      debugPrint(
        '🎉 [SuperAdminDataSource] Admin account created successfully!',
      );

      return AdminInvitationModel.fromJson(invitationResponse);
    } on PostgrestException catch (e) {
      debugPrint('❌ [SuperAdminDataSource] PostgrestException: ${e.message}');
      debugPrint('   Code: ${e.code}');
      debugPrint('   Details: ${e.details}');

      if (e.code == '23505') {
        // Unique constraint violation
        throw ConflictException('Email already exists');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      // Catch any other auth or server errors
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
          .select()
          .order('name', ascending: true);

      final cities = (response as List)
          .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
          .toList();

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
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      final cities = (response as List)
          .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
          .toList();

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
