import 'package:equatable/equatable.dart';

/// Owner revenue statistics entity
///
/// Contains revenue and booking analytics for a field owner
class OwnerRevenueEntity extends Equatable {
  /// Total all-time revenue for owner's fields
  final double totalRevenue;

  /// Revenue for current month
  final double monthlyRevenue;

  /// Total number of bookings across all fields
  final int totalBookings;

  /// Number of bookings in current month
  final int monthlyBookings;

  /// Number of pending bookings awaiting approval
  final int pendingBookings;

  /// Revenue breakdown by field ID
  final Map<String, double> revenueByField;

  const OwnerRevenueEntity({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalBookings,
    required this.monthlyBookings,
    required this.pendingBookings,
    required this.revenueByField,
  });

  /// Calculate average revenue per booking
  double get averageRevenuePerBooking {
    if (totalBookings == 0) return 0;
    return totalRevenue / totalBookings;
  }

  /// Calculate revenue growth rate (monthly vs total)
  double get revenueGrowthRate {
    if (totalRevenue == 0) return 0;
    return (monthlyRevenue / totalRevenue) * 100;
  }

  @override
  List<Object?> get props => [
    totalRevenue,
    monthlyRevenue,
    totalBookings,
    monthlyBookings,
    pendingBookings,
    revenueByField,
  ];

  @override
  bool get stringify => true;
}
