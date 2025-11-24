import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';

/// Data model for admin invitation.
///
/// Maps database table `admin_invitations` to/from JSON.
/// Extends domain entity for use in data layer.
class AdminInvitationModel extends AdminInvitationEntity {
  const AdminInvitationModel({
    required super.id,
    required super.email,
    required super.defaultPassword,
    required super.fullName,
    super.phone,
    required super.createdBy,
    super.adminId,
    required super.status,
    required super.createdAt,
    super.acceptedAt,
  });

  /// Create model from JSON (database response).
  factory AdminInvitationModel.fromJson(Map<String, dynamic> json) {
    return AdminInvitationModel(
      id: json['id'] as String,
      email: json['email'] as String,
      defaultPassword: json['default_password'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      createdBy: json['created_by'] as String,
      adminId: json['admin_id'] as String?,
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
    );
  }

  /// Convert model to JSON for database insert.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'default_password': defaultPassword,
      'full_name': fullName,
      if (phone != null) 'phone': phone,
      'created_by': createdBy,
      if (adminId != null) 'admin_id': adminId,
      'status': _statusToString(status),
      'created_at': createdAt.toIso8601String(),
      if (acceptedAt != null) 'accepted_at': acceptedAt!.toIso8601String(),
    };
  }

  /// Convert model to JSON for insert (excludes id and timestamps).
  Map<String, dynamic> toInsertJson() {
    return {
      'email': email,
      'default_password': defaultPassword,
      'full_name': fullName,
      if (phone != null) 'phone': phone,
      'created_by': createdBy,
      'status': 'pending',
    };
  }

  /// Parse status string to enum
  static AdminInvitationStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return AdminInvitationStatus.pending;
      case 'accepted':
        return AdminInvitationStatus.accepted;
      case 'expired':
        return AdminInvitationStatus.expired;
      default:
        return AdminInvitationStatus.pending;
    }
  }

  /// Convert status enum to string
  static String _statusToString(AdminInvitationStatus status) {
    switch (status) {
      case AdminInvitationStatus.pending:
        return 'pending';
      case AdminInvitationStatus.accepted:
        return 'accepted';
      case AdminInvitationStatus.expired:
        return 'expired';
    }
  }

  @override
  String toString() {
    return 'AdminInvitationModel(${super.toString()})';
  }
}
