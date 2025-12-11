import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';

/// State for user details screen.
///
/// Manages user data, bookings, and action states.
sealed class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class UserDetailsLoading extends UserDetailsState {
  const UserDetailsLoading();
}

/// User details loaded successfully.
final class UserDetailsLoaded extends UserDetailsState {
  final UserEntity user;
  final List<BookingEntity> bookings;
  final UserDetailsStats stats;
  final bool isTogglingStatus;
  final bool showStatusDialog;

  const UserDetailsLoaded({
    required this.user,
    this.bookings = const [],
    required this.stats,
    this.isTogglingStatus = false,
    this.showStatusDialog = false,
  });

  UserDetailsLoaded copyWith({
    UserEntity? user,
    List<BookingEntity>? bookings,
    UserDetailsStats? stats,
    bool? isTogglingStatus,
    bool? showStatusDialog,
  }) {
    return UserDetailsLoaded(
      user: user ?? this.user,
      bookings: bookings ?? this.bookings,
      stats: stats ?? this.stats,
      isTogglingStatus: isTogglingStatus ?? this.isTogglingStatus,
      showStatusDialog: showStatusDialog ?? this.showStatusDialog,
    );
  }

  @override
  List<Object?> get props => [
    user,
    bookings,
    stats,
    isTogglingStatus,
    showStatusDialog,
  ];
}

/// Status toggle completed successfully.
final class UserStatusToggled extends UserDetailsState {
  final UserEntity user;
  final bool wasActivated;

  const UserStatusToggled({required this.user, required this.wasActivated});

  String get message => wasActivated
      ? 'User activated successfully'
      : 'User deactivated successfully';

  @override
  List<Object?> get props => [user, wasActivated];
}

/// Error state.
final class UserDetailsError extends UserDetailsState {
  final String message;
  final UserEntity? user;

  const UserDetailsError({required this.message, this.user});

  @override
  List<Object?> get props => [message, user];
}

/// Statistics for user details.
class UserDetailsStats extends Equatable {
  final int totalBookings;
  final int completedBookings;
  final int cancelledBookings;
  final int pendingBookings;
  final double totalSpent;
  final int memberDays;
  final String? favoriteField;

  const UserDetailsStats({
    this.totalBookings = 0,
    this.completedBookings = 0,
    this.cancelledBookings = 0,
    this.pendingBookings = 0,
    this.totalSpent = 0,
    this.memberDays = 0,
    this.favoriteField,
  });

  factory UserDetailsStats.fromBookings(
    List<BookingEntity> bookings,
    DateTime memberSince,
  ) {
    final completed = bookings
        .where((b) => b.status == BookingStatus.completed)
        .length;
    final cancelled = bookings
        .where((b) => b.status == BookingStatus.canceled)
        .length;
    final pending = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;

    final totalSpent = bookings
        .where((b) => b.status == BookingStatus.completed)
        .fold<double>(0, (sum, b) => sum + b.totalPrice);

    final fieldCounts = <String, int>{};
    for (final booking in bookings) {
      final fieldName = booking.fieldName ?? 'Unknown';
      fieldCounts[fieldName] = (fieldCounts[fieldName] ?? 0) + 1;
    }

    String? favorite;
    int maxCount = 0;
    fieldCounts.forEach((field, count) {
      if (count > maxCount) {
        maxCount = count;
        favorite = field;
      }
    });

    return UserDetailsStats(
      totalBookings: bookings.length,
      completedBookings: completed,
      cancelledBookings: cancelled,
      pendingBookings: pending,
      totalSpent: totalSpent,
      memberDays: DateTime.now().difference(memberSince).inDays,
      favoriteField: favorite,
    );
  }

  @override
  List<Object?> get props => [
    totalBookings,
    completedBookings,
    cancelledBookings,
    pendingBookings,
    totalSpent,
    memberDays,
    favoriteField,
  ];
}
