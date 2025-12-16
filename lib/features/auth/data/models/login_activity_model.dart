import 'package:spo_kick/features/auth/domain/entities/login_activity_entity.dart';

/// Login Activity Model
///
/// Data transfer object for login activity with JSON serialization.
class LoginActivityModel extends LoginActivityEntity {
  const LoginActivityModel({
    required super.id,
    required super.userId,
    required super.timestamp,
    super.ipAddress,
    super.deviceType,
    super.deviceName,
    super.location,
    super.status,
    super.userAgent,
    super.isCurrentSession,
    super.userName,
    super.userEmail,
    super.userRole,
  });

  /// Create from JSON map.
  factory LoginActivityModel.fromJson(Map<String, dynamic> json) {
    // Parse user data from nested profiles join if available
    String? userName;
    String? userEmail;
    String? userRole;

    if (json['profiles'] != null && json['profiles'] is Map) {
      final profile = json['profiles'] as Map<String, dynamic>;
      userName = profile['full_name'] as String?;
      userEmail = profile['email'] as String?;
      userRole = profile['role'] as String?;
    } else {
      // Fallback: check if user data is at root level (from view)
      userName = json['user_name'] as String? ?? json['full_name'] as String?;
      userEmail = json['user_email'] as String? ?? json['email'] as String?;
      userRole = json['user_role'] as String? ?? json['role'] as String?;
    }

    return LoginActivityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ipAddress: json['ip_address'] as String?,
      deviceType: DeviceType.fromString(json['device_type'] as String?),
      deviceName: json['device_name'] as String?,
      location: json['location'] as String?,
      status: LoginStatus.fromString(json['status'] as String?),
      userAgent: json['user_agent'] as String?,
      isCurrentSession: json['is_current_session'] as bool? ?? false,
      userName: userName,
      userEmail: userEmail,
      userRole: userRole,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'ip_address': ipAddress,
      'device_type': deviceType.name,
      'device_name': deviceName,
      'location': location,
      'status': status.name,
      'user_agent': userAgent,
    };
  }

  /// Convert to JSON map for insert (without id).
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'ip_address': ipAddress,
      'device_type': deviceType.name,
      'device_name': deviceName,
      'location': location,
      'status': status.name,
      'user_agent': userAgent,
    };
  }

  /// Create from entity.
  factory LoginActivityModel.fromEntity(LoginActivityEntity entity) {
    return LoginActivityModel(
      id: entity.id,
      userId: entity.userId,
      timestamp: entity.timestamp,
      ipAddress: entity.ipAddress,
      deviceType: entity.deviceType,
      deviceName: entity.deviceName,
      location: entity.location,
      status: entity.status,
      userAgent: entity.userAgent,
      isCurrentSession: entity.isCurrentSession,
      userName: entity.userName,
      userEmail: entity.userEmail,
      userRole: entity.userRole,
    );
  }
}
