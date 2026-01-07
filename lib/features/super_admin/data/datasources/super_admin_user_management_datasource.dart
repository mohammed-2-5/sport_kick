import 'package:spo_kick/features/auth/data/models/user_model.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_admin_operations_datasource.dart';
import 'package:spo_kick/features/super_admin/data/datasources/super_admin_user_queries_datasource.dart';
import 'package:spo_kick/features/super_admin/data/models/admin_invitation_model.dart';

/// Remote data source for super admin user management operations.
///
/// This is a facade that delegates to specialized datasources:
/// - SuperAdminAdminOperationsDataSource: Admin creation and password reset
/// - SuperAdminUserQueriesDataSource: User listing and activation/deactivation
///
/// Handles:
/// - Admin account creation
/// - User listing (admins and regular users)
/// - User activation/deactivation
/// - Admin password reset
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

/// Facade implementation that delegates to specialized datasources.
class SuperAdminUserManagementDataSourceImpl
    implements SuperAdminUserManagementDataSource {
  final SuperAdminAdminOperationsDataSource _adminOperationsDataSource;
  final SuperAdminUserQueriesDataSource _userQueriesDataSource;

  SuperAdminUserManagementDataSourceImpl({
    required SuperAdminAdminOperationsDataSource adminOperationsDataSource,
    required SuperAdminUserQueriesDataSource userQueriesDataSource,
  }) : _adminOperationsDataSource = adminOperationsDataSource,
       _userQueriesDataSource = userQueriesDataSource;

  // ==================== Admin Operations ====================

  @override
  Future<AdminInvitationModel> createAdminAccount({
    required String email,
    required String fullName,
    String? phone,
    String? defaultPassword,
  }) {
    return _adminOperationsDataSource.createAdminAccount(
      email: email,
      fullName: fullName,
      phone: phone,
      defaultPassword: defaultPassword,
    );
  }

  @override
  Future<String> resetAdminPassword(String adminId) {
    return _adminOperationsDataSource.resetAdminPassword(adminId);
  }

  // ==================== User Queries and Status Operations ====================

  @override
  Future<List<UserModel>> getAllAdmins() {
    return _userQueriesDataSource.getAllAdmins();
  }

  @override
  Future<List<UserModel>> getAllUsers() {
    return _userQueriesDataSource.getAllUsers();
  }

  @override
  Future<void> activateUser(String userId) {
    return _userQueriesDataSource.activateUser(userId);
  }

  @override
  Future<void> deactivateUser(String userId) {
    return _userQueriesDataSource.deactivateUser(userId);
  }
}
