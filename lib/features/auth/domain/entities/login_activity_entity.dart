import 'package:equatable/equatable.dart';

/// Login status enumeration.
enum LoginStatus {
  success,
  failed,
  blocked;

  String get displayName {
    switch (this) {
      case LoginStatus.success:
        return 'Success';
      case LoginStatus.failed:
        return 'Failed';
      case LoginStatus.blocked:
        return 'Blocked';
    }
  }

  static LoginStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'success':
        return LoginStatus.success;
      case 'failed':
        return LoginStatus.failed;
      case 'blocked':
        return LoginStatus.blocked;
      default:
        return LoginStatus.success;
    }
  }
}

/// Device type enumeration.
enum DeviceType {
  mobile,
  web,
  desktop;

  String get displayName {
    switch (this) {
      case DeviceType.mobile:
        return 'Mobile';
      case DeviceType.web:
        return 'Web';
      case DeviceType.desktop:
        return 'Desktop';
    }
  }

  static DeviceType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'mobile':
        return DeviceType.mobile;
      case 'web':
        return DeviceType.web;
      case 'desktop':
        return DeviceType.desktop;
      default:
        return DeviceType.mobile;
    }
  }
}

/// Login Activity Entity
///
/// Represents a login event for security monitoring.
class LoginActivityEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String? ipAddress;
  final DeviceType deviceType;
  final String? deviceName;
  final String? location;
  final LoginStatus status;
  final String? userAgent;
  final bool isCurrentSession;

  const LoginActivityEntity({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.ipAddress,
    this.deviceType = DeviceType.mobile,
    this.deviceName,
    this.location,
    this.status = LoginStatus.success,
    this.userAgent,
    this.isCurrentSession = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    timestamp,
    ipAddress,
    deviceType,
    deviceName,
    location,
    status,
    userAgent,
    isCurrentSession,
  ];

  LoginActivityEntity copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    String? ipAddress,
    DeviceType? deviceType,
    String? deviceName,
    String? location,
    LoginStatus? status,
    String? userAgent,
    bool? isCurrentSession,
  }) {
    return LoginActivityEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      ipAddress: ipAddress ?? this.ipAddress,
      deviceType: deviceType ?? this.deviceType,
      deviceName: deviceName ?? this.deviceName,
      location: location ?? this.location,
      status: status ?? this.status,
      userAgent: userAgent ?? this.userAgent,
      isCurrentSession: isCurrentSession ?? this.isCurrentSession,
    );
  }
}
