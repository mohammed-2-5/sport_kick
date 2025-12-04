import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';

/// Remote data source for super admin user management operations.
///
/// Handles:
/// - Admin account creation
/// - User listing (admins and regular users)
/// - User activation/deactivation
abstract class SuperAdminUserManagementDataSource {
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  });
  Future<List<UserModel>> getAllAdmins();
  Future<List<UserModel>> getAllUsers();
  Future<void> deactivateUser(String userId);
  Future<void> activateUser(String userId);
}

/// Implementation of super admin user management data source.
class SuperAdminUserManagementDataSourceImpl
    implements SuperAdminUserManagementDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminUserManagementDataSourceImpl({required this.supabaseClient});

  /// Get current user ID from Supabase auth.
  String get _currentUserId {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const AuthenticationException('User not authenticated');
    }
    return user.id;
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

      debugPrint(
        '🔐 [UserMgmtDataSource] Creating admin account via Edge Function...',
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
          '❌ [UserMgmtDataSource] Empty response from create-admin function',
        );
        throw const ServerException(
          'Failed to create admin account (empty response)',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['error'] != null) {
        // Edge function has returned an error object
        final String message = data['error'].toString();
        debugPrint('❌ [UserMgmtDataSource] Edge function error: $message');

        // Optionally map some common errors to ConflictException, etc.
        if (message.toLowerCase().contains('already exists')) {
          throw const ConflictException('Email already exists');
        }

        throw ServerException('Failed to create admin account: $message');
      }

      debugPrint(
        '🎉 [UserMgmtDataSource] Admin account created successfully via Edge Function',
      );

      // Map the received JSON to your model
      return AdminInvitationModel.fromJson(data);
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('already exists') ||
          e.toString().contains('already registered')) {
        debugPrint('❌ [UserMgmtDataSource] Email conflict: $e');
        throw const ConflictException('Email already exists');
      }
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      throw ServerException('Failed to create admin account: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllAdmins() async {
    try {
      debugPrint('👥 [UserMgmtDataSource] Fetching all admins...');

      final response = await supabaseClient
          .from('profiles')
          .select()
          .inFilter('role', ['admin', 'super_admin'])
          .order('created_at', ascending: false);

      final admins = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ [UserMgmtDataSource] Loaded ${admins.length} admins');
      return admins;
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      throw ServerException('Failed to load admins: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      debugPrint('👥 [UserMgmtDataSource] Fetching all users...');

      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('role', 'user')
          .order('created_at', ascending: false);

      final users = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ [UserMgmtDataSource] Loaded ${users.length} users');
      return users;
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      throw ServerException('Failed to load users: $e');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      debugPrint('🚫 [UserMgmtDataSource] Deactivating user: $userId');

      await supabaseClient
          .from('profiles')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('✅ User deactivated');
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      throw ServerException('Failed to deactivate user: $e');
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      debugPrint('✅ [UserMgmtDataSource] Activating user: $userId');

      await supabaseClient
          .from('profiles')
          .update({
            'is_active': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('✅ User activated');
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
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
