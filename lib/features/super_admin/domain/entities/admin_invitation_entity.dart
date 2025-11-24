import 'package:equatable/equatable.dart';

/// Admin invitation status
enum AdminInvitationStatus {
  /// Admin account created but not yet logged in
  pending,

  /// Admin has logged in and changed password
  accepted,

  /// Invitation expired (not used currently)
  expired,
}

/// Admin invitation entity tracking admin account creation.
///
/// Represents an admin account invitation created by super admin.
/// Tracks the invitation status and default password for new admins.
///
/// Usage:
/// ```dart
/// final invitation = AdminInvitationEntity(
///   email: 'admin@field.com',
///   defaultPassword: 'FieldAdmin2024@123',
///   fullName: 'John Doe',
///   phone: '+201234567890',
/// );
/// ```
class AdminInvitationEntity extends Equatable {
  /// Unique invitation ID
  final String id;

  /// Email address for the new admin
  final String email;

  /// Default password generated for the admin
  /// Admin must change this on first login
  final String defaultPassword;

  /// Full name of the admin
  final String fullName;

  /// Phone number of the admin (optional)
  final String? phone;

  /// Super admin who created this invitation
  final String createdBy;

  /// ID of the admin account (set after account created)
  final String? adminId;

  /// Current status of the invitation
  final AdminInvitationStatus status;

  /// When the invitation was created
  final DateTime createdAt;

  /// When the admin accepted and logged in (null if pending)
  final DateTime? acceptedAt;

  const AdminInvitationEntity({
    required this.id,
    required this.email,
    required this.defaultPassword,
    required this.fullName,
    this.phone,
    required this.createdBy,
    this.adminId,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
  });

  /// Returns true if invitation is still pending
  bool get isPending => status == AdminInvitationStatus.pending;

  /// Returns true if admin has accepted and logged in
  bool get isAccepted => status == AdminInvitationStatus.accepted;

  /// Returns true if invitation has expired
  bool get isExpired => status == AdminInvitationStatus.expired;

  /// Returns true if admin account has been created
  bool get hasAdminAccount => adminId != null;

  /// Get formatted status text
  String get statusText {
    switch (status) {
      case AdminInvitationStatus.pending:
        return 'Pending';
      case AdminInvitationStatus.accepted:
        return 'Accepted';
      case AdminInvitationStatus.expired:
        return 'Expired';
    }
  }

  /// Get how many days ago this invitation was created
  int get daysAgo {
    return DateTime.now().difference(createdAt).inDays;
  }

  /// Create a copy with updated fields
  AdminInvitationEntity copyWith({
    String? id,
    String? email,
    String? defaultPassword,
    String? fullName,
    String? phone,
    String? createdBy,
    String? adminId,
    AdminInvitationStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
  }) {
    return AdminInvitationEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      defaultPassword: defaultPassword ?? this.defaultPassword,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdBy: createdBy ?? this.createdBy,
      adminId: adminId ?? this.adminId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    defaultPassword,
    fullName,
    phone,
    createdBy,
    adminId,
    status,
    createdAt,
    acceptedAt,
  ];

  @override
  String toString() {
    return 'AdminInvitationEntity('
        'id: $id, '
        'email: $email, '
        'status: $statusText, '
        'hasAccount: $hasAdminAccount'
        ')';
  }
}
