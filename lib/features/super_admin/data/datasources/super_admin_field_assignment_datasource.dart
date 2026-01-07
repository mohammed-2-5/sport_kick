import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseClient, PostgrestException;
import 'package:spo_kick/core/errors/exceptions.dart';

/// Remote data source for super admin field assignment operations.
///
/// Handles:
/// - Assigning fields to admin users
/// - Creating audit trail for field assignments
abstract class SuperAdminFieldAssignmentDataSource {
  Future<void> assignFieldToAdmin({
    required String adminId,
    required String fieldId,
    String? notes,
  });
}

/// Implementation of super admin field assignment data source.
class SuperAdminFieldAssignmentDataSourceImpl
    implements SuperAdminFieldAssignmentDataSource {
  final SupabaseClient supabaseClient;

  SuperAdminFieldAssignmentDataSourceImpl({required this.supabaseClient});

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

      debugPrint('🔗 [FieldAssignmentDataSource] Assigning field to admin...');
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
      debugPrint('🎉 [FieldAssignmentDataSource] Field assigned successfully!');
    } on PostgrestException catch (e) {
      debugPrint(
        '❌ [FieldAssignmentDataSource] PostgrestException: ${e.message}',
      );
      debugPrint('   Code: ${e.code}');

      if (e.code == 'PGRST116') {
        throw const NotFoundException('Admin or field not found');
      }

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      debugPrint('❌ [FieldAssignmentDataSource] Exception: $e');
      throw ServerException('Failed to assign field: $e');
    }
  }
}
