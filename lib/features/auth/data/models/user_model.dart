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
    super.passwordChanged,
    required super.createdAt,
    required super.updatedAt,
    super.selectedCityId,
    super.fieldsCount,
    super.totalRevenue,
  });

  /// Creates a [UserModel] from JSON data.
  ///
  /// This is typically used when receiving data from Supabase.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse fields count from nested array if present
    int fieldsCount = 0;
    double totalRevenue = 0.0;

    if (json['fields'] != null && json['fields'] is List) {
      final fieldsList = json['fields'] as List;
      fieldsCount = fieldsList.length;

      // Calculate revenue from bookings in each field
      for (final field in fieldsList) {
        if (field is Map<String, dynamic> && field['bookings'] != null) {
          final bookings = field['bookings'] as List;
          for (final booking in bookings) {
            if (booking is Map<String, dynamic>) {
              final status = booking['status'] as String?;
              // Only count confirmed and completed bookings for revenue
              if (status == 'confirmed' || status == 'completed') {
                final price = booking['total_price'];
                if (price != null) {
                  totalRevenue += (price as num).toDouble();
                }
              }
            }
          }
        }
      }
    } else if (json['fields_count'] != null) {
      fieldsCount = json['fields_count'] as int;
    }

    // Fallback: if total_revenue is directly provided
    if (json['total_revenue'] != null) {
      totalRevenue = (json['total_revenue'] as num).toDouble();
    }

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
      passwordChanged: json['password_changed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      selectedCityId: json['selected_city_id'] as String?,
      fieldsCount: fieldsCount,
      totalRevenue: totalRevenue,
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
      'password_changed': passwordChanged,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (selectedCityId != null) 'selected_city_id': selectedCityId,
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
      passwordChanged: entity.passwordChanged,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      selectedCityId: entity.selectedCityId,
      fieldsCount: entity.fieldsCount,
      totalRevenue: entity.totalRevenue,
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
    bool? passwordChanged,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? selectedCityId,
    int? fieldsCount,
    double? totalRevenue,
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
      passwordChanged: passwordChanged ?? this.passwordChanged,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      fieldsCount: fieldsCount ?? this.fieldsCount,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }
}
