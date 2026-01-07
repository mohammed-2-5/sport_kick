import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/statistics/statistics_state.dart';

/// Cubit for managing platform statistics.
///
/// Handles loading and displaying platform-wide statistics including
/// user counts, field counts, bookings, and revenue analytics.
class StatisticsCubit extends Cubit<StatisticsState> {
  final GetPlatformStatisticsUseCase getPlatformStatisticsUseCase;
  final GetAllBookingsUseCase getAllBookingsUseCase;
  final GetAllFieldsUseCase getAllFieldsUseCase;

  StatisticsCubit({
    required this.getPlatformStatisticsUseCase,
    required this.getAllBookingsUseCase,
    required this.getAllFieldsUseCase,
  }) : super(const StatisticsInitial());

  /// Load platform-wide statistics for dashboard.
  Future<void> loadPlatformStatistics() async {
    debugPrint('🔄 [StatisticsCubit] Loading platform statistics...');
    emit(const StatisticsLoading(message: 'Loading statistics...'));

    final result = await getPlatformStatisticsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [StatisticsCubit] Error loading statistics: ${failure.message}',
        );
        emit(StatisticsError(failure.message));
      },
      (statistics) {
        debugPrint('✅ [StatisticsCubit] Platform statistics loaded');
        debugPrint('   Users: ${statistics.totalUsers}');
        debugPrint('   Admins: ${statistics.totalAdmins}');
        debugPrint('   Fields: ${statistics.activeFields}');
        debugPrint('   Bookings: ${statistics.totalBookings}');
        emit(PlatformStatisticsLoaded(statistics));
      },
    );
  }

  /// Load all analytics data (bookings, fields, and statistics).
  ///
  /// This method loads all data needed for the analytics page and emits
  /// a single combined state with all the data.
  Future<void> loadAnalyticsData() async {
    debugPrint('🔄 [StatisticsCubit] Loading analytics data...');
    emit(const StatisticsLoading(message: 'Loading analytics...'));

    // Load bookings
    final bookingsResult = await getAllBookingsUseCase();
    if (bookingsResult.isLeft()) {
      final failure = bookingsResult.fold((l) => l, (r) => null);
      emit(StatisticsError(failure?.message ?? 'Failed to load bookings'));
      return;
    }
    final bookings = bookingsResult.fold((l) => <BookingEntity>[], (r) => r);

    // Load fields
    final fieldsResult = await getAllFieldsUseCase();
    if (fieldsResult.isLeft()) {
      final failure = fieldsResult.fold((l) => l, (r) => null);
      emit(StatisticsError(failure?.message ?? 'Failed to load fields'));
      return;
    }
    final fields = fieldsResult.fold((l) => <FieldEntity>[], (r) => r);

    // Load statistics
    final statsResult = await getPlatformStatisticsUseCase();
    final statistics = statsResult.fold((l) => null, (r) => r);

    debugPrint('✅ [StatisticsCubit] Analytics data loaded');
    debugPrint('   Bookings: ${bookings.length}');
    debugPrint('   Fields: ${fields.length}');

    emit(
      AnalyticsDataLoaded(
        bookings: bookings,
        fields: fields,
        statistics: statistics,
      ),
    );
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [StatisticsCubit] Resetting state');
    emit(const StatisticsInitial());
  }
}
