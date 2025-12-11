import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// State for owner dashboard.
///
/// Manages:
/// - Dashboard data (fields, bookings, revenue)
/// - Navigation drawer state
/// - Quick actions
sealed class OwnerDashboardState extends Equatable {
  const OwnerDashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class OwnerDashboardLoading extends OwnerDashboardState {
  const OwnerDashboardLoading();
}

/// Dashboard data loaded successfully.
final class OwnerDashboardLoaded extends OwnerDashboardState {
  final String ownerName;
  final List<FieldEntity> fields;
  final List<BookingEntity> recentBookings;
  final OwnerDashboardStats stats;
  final int selectedNavIndex;
  final bool isDrawerOpen;
  final bool isRefreshing;

  const OwnerDashboardLoaded({
    required this.ownerName,
    this.fields = const [],
    this.recentBookings = const [],
    required this.stats,
    this.selectedNavIndex = 0,
    this.isDrawerOpen = false,
    this.isRefreshing = false,
  });

  OwnerDashboardLoaded copyWith({
    String? ownerName,
    List<FieldEntity>? fields,
    List<BookingEntity>? recentBookings,
    OwnerDashboardStats? stats,
    int? selectedNavIndex,
    bool? isDrawerOpen,
    bool? isRefreshing,
  }) {
    return OwnerDashboardLoaded(
      ownerName: ownerName ?? this.ownerName,
      fields: fields ?? this.fields,
      recentBookings: recentBookings ?? this.recentBookings,
      stats: stats ?? this.stats,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    ownerName,
    fields,
    recentBookings,
    stats,
    selectedNavIndex,
    isDrawerOpen,
    isRefreshing,
  ];
}

/// Error state.
final class OwnerDashboardError extends OwnerDashboardState {
  final String message;

  const OwnerDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Dashboard statistics.
class OwnerDashboardStats extends Equatable {
  final int totalFields;
  final int activeFields;
  final int totalBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int todayBookings;
  final double totalRevenue;
  final double monthlyRevenue;
  final double weeklyRevenue;
  final double averageRating;
  final int totalReviews;

  const OwnerDashboardStats({
    this.totalFields = 0,
    this.activeFields = 0,
    this.totalBookings = 0,
    this.pendingBookings = 0,
    this.confirmedBookings = 0,
    this.todayBookings = 0,
    this.totalRevenue = 0,
    this.monthlyRevenue = 0,
    this.weeklyRevenue = 0,
    this.averageRating = 0,
    this.totalReviews = 0,
  });

  factory OwnerDashboardStats.fromData(
    List<FieldEntity> fields,
    List<BookingEntity> bookings,
  ) {
    final activeFields = fields.where((f) => f.isActive).length;
    final pendingBookings = bookings
        .where((b) => b.status.name == 'pending')
        .length;
    final confirmedBookings = bookings
        .where((b) => b.status.name == 'confirmed')
        .length;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayBookings = bookings.where((b) {
      final bookingDate = DateTime(b.date.year, b.date.month, b.date.day);
      return bookingDate == today;
    }).length;

    final completedBookings = bookings.where(
      (b) => b.status.name == 'completed',
    );
    final totalRevenue = completedBookings.fold<double>(
      0,
      (sum, b) => sum + b.totalPrice,
    );

    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    final weeklyRevenue = completedBookings
        .where((b) => b.createdAt.isAfter(weekAgo))
        .fold<double>(0, (sum, b) => sum + b.totalPrice);

    final monthlyRevenue = completedBookings
        .where((b) => b.createdAt.isAfter(monthAgo))
        .fold<double>(0, (sum, b) => sum + b.totalPrice);

    double totalRating = 0;
    int ratingCount = 0;
    for (final field in fields) {
      final rating = field.averageRating ?? 0;
      if (rating > 0) {
        totalRating += rating;
        ratingCount++;
      }
    }

    return OwnerDashboardStats(
      totalFields: fields.length,
      activeFields: activeFields,
      totalBookings: bookings.length,
      pendingBookings: pendingBookings,
      confirmedBookings: confirmedBookings,
      todayBookings: todayBookings,
      totalRevenue: totalRevenue,
      monthlyRevenue: monthlyRevenue,
      weeklyRevenue: weeklyRevenue,
      averageRating: ratingCount > 0 ? totalRating / ratingCount : 0,
      totalReviews: fields.fold<int>(0, (sum, f) => sum + f.totalReviews),
    );
  }

  @override
  List<Object?> get props => [
    totalFields,
    activeFields,
    totalBookings,
    pendingBookings,
    confirmedBookings,
    todayBookings,
    totalRevenue,
    monthlyRevenue,
    weeklyRevenue,
    averageRating,
    totalReviews,
  ];
}
