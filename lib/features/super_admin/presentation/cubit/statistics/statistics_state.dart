import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

/// Base state for statistics operations.
sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

/// Loading state.
class StatisticsLoading extends StatisticsState {
  final String message;

  const StatisticsLoading({this.message = 'Loading statistics...'});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Platform statistics loaded successfully.
class PlatformStatisticsLoaded extends StatisticsState {
  final PlatformStatisticsEntity statistics;

  const PlatformStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

/// Combined analytics data loaded successfully.
class AnalyticsDataLoaded extends StatisticsState {
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final PlatformStatisticsEntity? statistics;

  const AnalyticsDataLoaded({
    required this.bookings,
    required this.fields,
    this.statistics,
  });

  @override
  List<Object?> get props => [bookings, fields, statistics];
}
