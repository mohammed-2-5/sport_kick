import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/features/auth/data/models/user_model.dart';

/// Remote data source for super admin user query and status operations.
///
/// Handles:
/// - User listing (admins and regular users)
/// - User activation/deactivation
abstract class SuperAdminUserQueriesDataSource {
  Future<List<UserModel>> getAllAdmins();
  Future<List<UserModel>> getAllUsers();
  Future<void> deactivateUser(String userId);
  Future<void> activateUser(String userId);
}

/// Implementation of super admin user queries data source.
class SuperAdminUserQueriesDataSourceImpl
    implements SuperAdminUserQueriesDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminUserQueriesDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<UserModel>> getAllAdmins() async {
    try {
      debugPrint(
        '👥 [UserQueriesDataSource] Fetching all admins with fields and revenue...',
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
        '✅ [UserQueriesDataSource] Loaded ${admins.length} admins with revenue data',
      );
      return admins;
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserQueriesDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserQueriesDataSource] Exception: $e');
      throw ServerException('Failed to load admins: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      debugPrint('👥 [UserQueriesDataSource] Fetching all users...');

      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('role', 'user')
          .order('created_at', ascending: false);

      final users = (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ [UserQueriesDataSource] Loaded ${users.length} users');
      return users;
    } on PostgrestException catch (e) {
      debugPrint('❌ [UserQueriesDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserQueriesDataSource] Exception: $e');
      throw ServerException('Failed to load users: $e');
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      debugPrint('🚫 [UserQueriesDataSource] Deactivating user: $userId');

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
      debugPrint('❌ [UserQueriesDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserQueriesDataSource] Exception: $e');
      throw ServerException('Failed to deactivate user: $e');
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      debugPrint('✅ [UserQueriesDataSource] Activating user: $userId');

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
      debugPrint('❌ [UserQueriesDataSource] PostgrestException: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [UserQueriesDataSource] Exception: $e');
      throw ServerException('Failed to activate user: $e');
    }
  }
}
