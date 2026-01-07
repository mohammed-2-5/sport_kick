import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

/// Base state for owner revenue operations.
sealed class OwnerRevenueState extends Equatable {
  const OwnerRevenueState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OwnerRevenueInitial extends OwnerRevenueState {
  const OwnerRevenueInitial();
}

/// Loading state with optional message
class OwnerRevenueLoading extends OwnerRevenueState {
  final String message;

  const OwnerRevenueLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state
class OwnerRevenueError extends OwnerRevenueState {
  final String message;

  const OwnerRevenueError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Revenue loaded successfully
class OwnerRevenueLoaded extends OwnerRevenueState {
  final OwnerRevenueEntity revenue;

  const OwnerRevenueLoaded(this.revenue);

  @override
  List<Object?> get props => [revenue];
}
