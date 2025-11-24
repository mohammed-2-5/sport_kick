import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

/// Data model for platform statistics.
///
/// Maps database view `platform_statistics` to/from JSON.
/// Extends domain entity for use in data layer.
class PlatformStatisticsModel extends PlatformStatisticsEntity {
  const PlatformStatisticsModel({
    required super.totalUsers,
    required super.newUsersThisMonth,
    required super.totalAdmins,
    required super.activeFields,
    required super.totalFields,
    required super.citiesWithFields,
    required super.activeCities,
    required super.totalBookings,
    required super.pendingBookings,
    required super.confirmedBookings,
    required super.completedBookings,
    required super.canceledBookings,
    required super.manualBookings,
    required super.bookingsThisMonth,
    required super.totalRevenue,
    required super.revenueThisMonth,
  });

  /// Create model from JSON (database response).
  ///
  /// Handles type conversion from database numeric types to Dart types.
  factory PlatformStatisticsModel.fromJson(Map<String, dynamic> json) {
    return PlatformStatisticsModel(
      totalUsers: _parseInt(json['total_users']),
      newUsersThisMonth: _parseInt(json['new_users_this_month']),
      totalAdmins: _parseInt(json['total_admins']),
      activeFields: _parseInt(json['active_fields']),
      totalFields: _parseInt(json['total_fields']),
      citiesWithFields: _parseInt(json['cities_with_fields']),
      activeCities: _parseInt(json['active_cities']),
      totalBookings: _parseInt(json['total_bookings']),
      pendingBookings: _parseInt(json['pending_bookings']),
      confirmedBookings: _parseInt(json['confirmed_bookings']),
      completedBookings: _parseInt(json['completed_bookings']),
      canceledBookings: _parseInt(json['canceled_bookings']),
      manualBookings: _parseInt(json['manual_bookings']),
      bookingsThisMonth: _parseInt(json['bookings_this_month']),
      totalRevenue: _parseDouble(json['total_revenue']),
      revenueThisMonth: _parseDouble(json['revenue_this_month']),
    );
  }

  /// Convert model to JSON (for API requests, if needed).
  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'new_users_this_month': newUsersThisMonth,
      'total_admins': totalAdmins,
      'active_fields': activeFields,
      'total_fields': totalFields,
      'cities_with_fields': citiesWithFields,
      'active_cities': activeCities,
      'total_bookings': totalBookings,
      'pending_bookings': pendingBookings,
      'confirmed_bookings': confirmedBookings,
      'completed_bookings': completedBookings,
      'canceled_bookings': canceledBookings,
      'manual_bookings': manualBookings,
      'bookings_this_month': bookingsThisMonth,
      'total_revenue': totalRevenue,
      'revenue_this_month': revenueThisMonth,
    };
  }

  /// Helper: Parse integer from dynamic type (handles null and different numeric types)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Helper: Parse double from dynamic type (handles null and different numeric types)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() {
    return 'PlatformStatisticsModel(${super.toString()})';
  }
}
