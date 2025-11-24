import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';

/// Data Transfer Object (DTO) for User.
///
/// Extends [UserEntity] and adds JSON serialization capabilities.
/// This model is used to convert between JSON (from API) and entities (for domain layer).
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.phone,
    super.role,
    super.isActive,
    super.avatarUrl,
    super.preferredSports,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a [UserModel] from JSON data.
  ///
  /// This is typically used when receiving data from Supabase.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'user',
      isActive: json['is_active'] as bool? ?? true,
      avatarUrl: json['avatar_url'] as String?,
      preferredSports: json['preferred_sports'] != null
          ? List<String>.from(json['preferred_sports'] as List)
          : [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts this [UserModel] to JSON.
  ///
  /// This is typically used when sending data to Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'avatar_url': avatarUrl,
      'preferred_sports': preferredSports,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converts this [UserModel] to a [UserEntity].
  ///
  /// Since UserModel extends UserEntity, this just returns itself.
  UserEntity toEntity() => this;

  /// Creates a [UserModel] from a [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      role: entity.role,
      isActive: entity.isActive,
      avatarUrl: entity.avatarUrl,
      preferredSports: entity.preferredSports,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Creates a copy of this user model with the given fields replaced with new values.
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    bool? isActive,
    String? avatarUrl,
    List<String>? preferredSports,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredSports: preferredSports ?? this.preferredSports,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
