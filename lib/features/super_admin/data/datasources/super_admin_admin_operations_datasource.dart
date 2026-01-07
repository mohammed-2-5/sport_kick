import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/utils/password_generator.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';

/// Remote data source for super admin admin-specific operations.
///
/// Handles:
/// - Admin account creation
/// - Admin password reset
abstract class SuperAdminAdminOperationsDataSource {
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  });
  Future<String> resetAdminPassword(String adminId);
}

/// Implementation of super admin admin operations data source.
class SuperAdminAdminOperationsDataSourceImpl
    implements SuperAdminAdminOperationsDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminAdminOperationsDataSourceImpl({required this.supabaseClient});

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
        '🔐 [AdminOpsDataSource] Creating admin account via Edge Function...',
      );
      debugPrint('   Email: $email');
      debugPrint('   Name: $fullName');
      debugPrint('   Created by: $currentUserId');

      final password =
          defaultPassword ?? PasswordGenerator.generateAdminPassword();
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
          '❌ [AdminOpsDataSource] Empty response from create-admin function',
        );
        throw const ServerException(
          'Failed to create admin account (empty response)',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['error'] != null) {
        // Edge function has returned an error object
        final String message = data['error'].toString();
        debugPrint('❌ [AdminOpsDataSource] Edge function error: $message');

        // Optionally map some common errors to ConflictException, etc.
        if (message.toLowerCase().contains('already exists')) {
          throw const ConflictException('Email already exists');
        }

        throw ServerException('Failed to create admin account: $message');
      }

      debugPrint(
        '🎉 [AdminOpsDataSource] Admin account created successfully via Edge Function',
      );

      // Map the received JSON to your model
      return AdminInvitationModel.fromJson(data);
    } on PostgrestException catch (e) {
      debugPrint('❌ [AdminOpsDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('already exists') ||
          e.toString().contains('already registered')) {
        debugPrint('❌ [AdminOpsDataSource] Email conflict: $e');
        throw const ConflictException('Email already exists');
      }
      debugPrint('❌ [AdminOpsDataSource] Exception: $e');
      throw ServerException('Failed to create admin account: $e');
    }
  }

  @override
  Future<String> resetAdminPassword(String adminId) async {
    try {
      debugPrint('🔐 [AdminOpsDataSource] Resetting admin password: $adminId');

      final newPassword = PasswordGenerator.generateAdminPassword();
      debugPrint('   Generated new password (local): $newPassword');

      final response = await supabaseClient.functions.invoke(
        'reset-admin-password',
        body: {'adminId': adminId},
      );

      if (response.data == null) {
        debugPrint('❌ [AdminOpsDataSource] Empty response from function');
        throw const ServerException(
          'Empty response from reset-password function',
        );
      }

      final data = response.data as Map<String, dynamic>;

      if (data['error'] != null) {
        final String message = data['error'].toString();
        debugPrint('❌ [AdminOpsDataSource] Edge Function error: $message');

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
        debugPrint('❌ [AdminOpsDataSource] No password in response');
        throw const ServerException('No password returned from function');
      }

      debugPrint('✅ [AdminOpsDataSource] Admin password reset successfully');
      return returnedPassword;
    } on NotFoundException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('❌ [AdminOpsDataSource] Exception: $e');
      if (e.toString().contains('not found')) {
        throw const NotFoundException('Admin not found');
      }
      throw ServerException('Failed to reset admin password: $e');
    }
  }
}
