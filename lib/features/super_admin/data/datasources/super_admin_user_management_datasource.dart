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
  Future<String> resetAdminPassword(String adminId);
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
      debugPrint(
        '👥 [UserMgmtDataSource] Fetching all admins with fields and revenue...',
      );

      // Query profiles with nested fields and their bookings for revenue calculation
      // Revenue = sum of total_price for confirmed/completed bookings
      final response = await supabaseClient
          .from('profiles')
          .select('''
            *,
            fields:fields(
              id,
              bookings:bookings(total_price, status)
            )
          ''')
          .inFilter('role', ['admin', 'super_admin'])
          .order('created_at', ascending: false);

      final admins = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint(
        '✅ [UserMgmtDataSource] Loaded ${admins.length} admins with revenue data',
      );
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

      // Check if user is an admin (has fields)
      final fieldsResponse = await supabaseClient
          .from('fields')
          .select('id')
          .eq('owner_id', userId);

      final fieldsCount = (fieldsResponse as List).length;

      // Deactivate the user
      await supabaseClient
          .from('profiles')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Also deactivate all fields owned by this admin
      if (fieldsCount > 0) {
        await supabaseClient
            .from('fields')
            .update({
              'is_active': false,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('owner_id', userId);
        debugPrint('✅ User and $fieldsCount fields deactivated');
      } else {
        debugPrint('✅ User deactivated (no fields owned)');
      }
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

      // Check if user is an admin (has fields)
      final fieldsResponse = await supabaseClient
          .from('fields')
          .select('id')
          .eq('owner_id', userId);

      final fieldsCount = (fieldsResponse as List).length;

      // Activate the user
      await supabaseClient
          .from('profiles')
          .update({
            'is_active': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Also activate all fields owned by this admin
      if (fieldsCount > 0) {
        await supabaseClient
            .from('fields')
            .update({
              'is_active': true,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('owner_id', userId);
        debugPrint('✅ User and $fieldsCount fields activated');
      } else {
        debugPrint('✅ User activated (no fields owned)');
      }
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserMgmtDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      throw ServerException('Failed to activate user: $e');
    }
  }

  @override
  Future<String> resetAdminPassword(String adminId) async {
    try {
      debugPrint('🔐 [UserMgmtDataSource] Resetting admin password: $adminId');

      final newPassword = _generateDefaultPassword();
      debugPrint('   Generated new password (local): $newPassword');

      final response = await supabaseClient.functions.invoke(
        'reset-admin-password',
        body: {'adminId': adminId},
      );

      if (response.data == null) {
        debugPrint('❌ [UserMgmtDataSource] Empty response from function');
        throw const ServerException(
          'Empty response from reset-password function',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['error'] != null) {
        final String message = data['error'].toString();
        debugPrint('❌ [UserMgmtDataSource] Edge Function error: $message');

        if (message.toLowerCase().contains('not found')) {
          throw const NotFoundException('Admin not found');
        }
        if (message.toLowerCase().contains('not an admin') ||
            message.toLowerCase().contains('real email')) {
          throw ValidationException(message);
        }
        throw ServerException('Failed to reset password: $message');
      }

      final returnedPassword = data['newPassword'] as String?;
      if (returnedPassword == null) {
        debugPrint('❌ [UserMgmtDataSource] No password in response');
        throw const ServerException('No password returned from function');
      }

      debugPrint('✅ [UserMgmtDataSource] Admin password reset successfully');
      return returnedPassword;
    } on NotFoundException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('❌ [UserMgmtDataSource] Exception: $e');
      if (e.toString().contains('not found')) {
        throw const NotFoundException('Admin not found');
      }
      throw ServerException('Failed to reset admin password: $e');
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
