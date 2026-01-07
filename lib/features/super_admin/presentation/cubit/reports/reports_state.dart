import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

/// Base state for reports cubit.
sealed class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

/// Loading state.
class ReportsLoading extends ReportsState {
  final String message;

  const ReportsLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Reports data loaded successfully.
class ReportsDataLoaded extends ReportsState {
  final List<UserEntity> users;
  final List<UserEntity> admins;
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final PlatformStatisticsEntity? statistics;

  const ReportsDataLoaded({
    required this.users,
    required this.admins,
    required this.bookings,
    required this.fields,
    this.statistics,
  });

  @override
  List<Object?> get props => [users, admins, bookings, fields, statistics];
}

/// Export in progress.
class ReportsExporting extends ReportsState {
  final String exportType;

  const ReportsExporting({required this.exportType});

  @override
  List<Object?> get props => [exportType];
}

/// Export completed successfully.
class ReportsExportSuccess extends ReportsState {
  final String message;

  const ReportsExportSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state.
class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
