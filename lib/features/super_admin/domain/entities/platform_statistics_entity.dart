import 'package:equatable/equatable.dart';

/// Platform-wide statistics entity for super admin dashboard.
///
/// Displays overview metrics across the entire platform including:
/// - User counts and growth
/// - Admin and field counts
/// - Booking statistics
/// - Revenue metrics
/// - City coverage
///
/// Usage:
/// ```dart
/// final stats = await getPlatformStatisticsUseCase();
/// print('Total Users: ${stats.totalUsers}');
/// print('Revenue: ${stats.totalRevenue}');
/// ```
class PlatformStatisticsEntity extends Equatable {
  /// Total number of active regular users
  final int totalUsers;

  /// Number of new users registered in last 30 days
  final int newUsersThisMonth;

  /// Total number of active admin accounts
  final int totalAdmins;

  /// Number of active fields in the platform
  final int activeFields;

  /// Total number of fields (including inactive)
  final int totalFields;

  /// Number of cities that have at least one field
  final int citiesWithFields;

  /// Number of active cities in the system
  final int activeCities;

  /// Total number of bookings (all time)
  final int totalBookings;

  /// Number of bookings awaiting approval
  final int pendingBookings;

  /// Number of approved bookings
  final int confirmedBookings;

  /// Number of completed bookings
  final int completedBookings;

  /// Number of canceled bookings
  final int canceledBookings;

  /// Number of manual bookings (created by admins)
  final int manualBookings;

  /// Number of bookings created in last 30 days
  final int bookingsThisMonth;

  /// Total revenue from confirmed and completed bookings
  final double totalRevenue;

  /// Revenue generated in last 30 days
  final double revenueThisMonth;

  /// Daily revenue for the last 7 days (in thousands, oldest to newest)
  final List<double> dailyRevenue;

  const PlatformStatisticsEntity({
    required this.totalUsers,
    required this.newUsersThisMonth,
    required this.totalAdmins,
    required this.activeFields,
    required this.totalFields,
    required this.citiesWithFields,
    required this.activeCities,
    required this.totalBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.completedBookings,
    required this.canceledBookings,
    required this.manualBookings,
    required this.bookingsThisMonth,
    required this.totalRevenue,
    required this.revenueThisMonth,
    this.dailyRevenue = const [],
  });

  /// Returns true if platform has any active users
  bool get hasUsers => totalUsers > 0;

  /// Returns true if platform has any admins
  bool get hasAdmins => totalAdmins > 0;

  /// Returns true if platform has any fields
  bool get hasFields => totalFields > 0;

  /// Returns true if platform has any bookings
  bool get hasBookings => totalBookings > 0;

  /// Calculate user growth rate (new users / total users)
  double get userGrowthRate {
    if (totalUsers == 0) return 0.0;
    return (newUsersThisMonth / totalUsers) * 100;
  }

  /// Calculate booking growth rate (this month / total)
  double get bookingGrowthRate {
    if (totalBookings == 0) return 0.0;
    return (bookingsThisMonth / totalBookings) * 100;
  }

  /// Calculate revenue growth rate (this month / total)
  double get revenueGrowthRate {
    if (totalRevenue == 0) return 0.0;
    return (revenueThisMonth / totalRevenue) * 100;
  }

  /// Calculate average revenue per booking
  double get averageRevenuePerBooking {
    final totalCompletedBookings = confirmedBookings + completedBookings;
    if (totalCompletedBookings == 0) return 0.0;
    return totalRevenue / totalCompletedBookings;
  }

  /// Get date labels for the last 7 days (Mon, Tue, Wed, etc.)
  List<String> get revenueDateLabels {
    final now = DateTime.now();
    final labels = <String>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ][date.weekday % 7];
      labels.add(dayName);
    }
    return labels;
  }

  /// Calculate field utilization rate (bookings / fields)
  double get fieldUtilizationRate {
    if (activeFields == 0) return 0.0;
    return totalBookings / activeFields;
  }

  /// Get number of inactive fields
  int get inactiveFields => totalFields - activeFields;

  /// Get formatted revenue string
  String get formattedRevenue {
    if (totalRevenue >= 1000000) {
      return '${(totalRevenue / 1000000).toStringAsFixed(2)}M';
    } else if (totalRevenue >= 1000) {
      return '${(totalRevenue / 1000).toStringAsFixed(1)}K';
    }
    return totalRevenue.toStringAsFixed(0);
  }

  @override
  List<Object?> get props => [
    totalUsers,
    newUsersThisMonth,
    totalAdmins,
    activeFields,
    totalFields,
    citiesWithFields,
    activeCities,
    totalBookings,
    pendingBookings,
    confirmedBookings,
    completedBookings,
    canceledBookings,
    manualBookings,
    bookingsThisMonth,
    totalRevenue,
    revenueThisMonth,
    dailyRevenue,
  ];

  @override
  String toString() {
    return 'PlatformStatisticsEntity('
        'users: $totalUsers, '
        'admins: $totalAdmins, '
        'fields: $activeFields, '
        'bookings: $totalBookings, '
        'revenue: $totalRevenue'
        ')';
  }
}
