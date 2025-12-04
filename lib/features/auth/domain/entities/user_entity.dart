import 'package:equatable/equatable.dart';

/// User entity representing the core user model in the domain layer.
///
/// This entity contains only the business logic properties and is
/// independent of any data source or framework.
class UserEntity extends Equatable {
  /// Unique identifier for the user (matches Supabase Auth user ID)
  final String id;

  /// User's email address
  final String email;

  /// User's full name
  final String? fullName;

  /// User's phone number
  final String? phone;

  /// User's role in the system
  /// Possible values: 'user', 'admin', 'super_admin'
  final String role;

  /// Whether the account is active (can log in and use the system)
  final bool isActive;

  /// URL to user's avatar/profile picture
  final String? avatarUrl;

  /// List of preferred sport category IDs
  final List<String> preferredSports;

  /// Whether the user has changed their password after first login
  final bool passwordChanged;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.role = 'user',
    this.isActive = true,
    this.avatarUrl,
    this.preferredSports = const [],
    this.passwordChanged = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of this user with the given fields replaced with new values
  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    bool? isActive,
    String? avatarUrl,
    List<String>? preferredSports,
    bool? passwordChanged,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredSports: preferredSports ?? this.preferredSports,
      passwordChanged: passwordChanged ?? this.passwordChanged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Checks if the user is a field owner/admin
  bool get isOwner => role == 'admin' || role == 'super_admin';

  /// Checks if the user is an admin
  bool get isAdmin => role == 'admin' || role == 'super_admin';

  /// Checks if the user is a super admin
  bool get isSuperAdmin => role == 'super_admin';

  /// Gets the user's display name (full name or email)
  String get displayName => fullName ?? email.split('@').first;

  /// Gets the user's initials for avatar placeholder
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    role,
    isActive,
    avatarUrl,
    preferredSports,
    passwordChanged,
    createdAt,
    updatedAt,
  ];

  @override
  bool get stringify => true;
}
