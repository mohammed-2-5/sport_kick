import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

/// Base state for owner profile.
sealed class OwnerProfileState extends Equatable {
  const OwnerProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class OwnerProfileInitial extends OwnerProfileState {
  const OwnerProfileInitial();
}

/// Loading profile data.
final class OwnerProfileLoading extends OwnerProfileState {
  const OwnerProfileLoading();
}

/// Profile data loaded successfully.
final class OwnerProfileLoaded extends OwnerProfileState {
  final int fieldsCount;
  final int bookingsCount;
  final OwnerRevenueEntity? revenue;
  final bool isRefreshing;

  const OwnerProfileLoaded({
    required this.fieldsCount,
    required this.bookingsCount,
    this.revenue,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [
    fieldsCount,
    bookingsCount,
    revenue,
    isRefreshing,
  ];

  OwnerProfileLoaded copyWith({
    int? fieldsCount,
    int? bookingsCount,
    OwnerRevenueEntity? revenue,
    bool? isRefreshing,
  }) {
    return OwnerProfileLoaded(
      fieldsCount: fieldsCount ?? this.fieldsCount,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      revenue: revenue ?? this.revenue,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

/// Error loading profile data.
final class OwnerProfileError extends OwnerProfileState {
  final String message;

  const OwnerProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
