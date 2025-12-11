import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Mixin for platform statistics operations.
///
/// Handles loading and displaying platform-wide statistics.
mixin StatisticsOperations on Cubit<SuperAdminState> {
  // Dependencies
  GetPlatformStatisticsUseCase get getPlatformStatisticsUseCase;
  GetAllBookingsUseCase get getAllBookingsUseCase;
  GetAllFieldsUseCase get getAllFieldsUseCase;

  /// Load platform-wide statistics for dashboard.
  Future<void> loadPlatformStatistics() async {
    debugPrint('🔄 [SuperAdminCubit] Loading platform statistics...');
    emit(const SuperAdminLoading(message: 'Loading statistics...'));

    final result = await getPlatformStatisticsUseCase();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [SuperAdminCubit] Error loading statistics: ${failure.message}',
        );
        emit(SuperAdminError(failure.message));
      },
      (statistics) {
        debugPrint('✅ [SuperAdminCubit] Platform statistics loaded');
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
    debugPrint('🔄 [SuperAdminCubit] Loading analytics data...');
    emit(const SuperAdminLoading(message: 'Loading analytics...'));

    // Load bookings
    final bookingsResult = await getAllBookingsUseCase();
    if (bookingsResult.isLeft()) {
      final failure = bookingsResult.fold((l) => l, (r) => null);
      emit(SuperAdminError(failure?.message ?? 'Failed to load bookings'));
      return;
    }
    final bookings = bookingsResult.fold((l) => <BookingEntity>[], (r) => r);

    // Load fields
    final fieldsResult = await getAllFieldsUseCase();
    if (fieldsResult.isLeft()) {
      final failure = fieldsResult.fold((l) => l, (r) => null);
      emit(SuperAdminError(failure?.message ?? 'Failed to load fields'));
      return;
    }
    final fields = fieldsResult.fold((l) => <FieldEntity>[], (r) => r);

    // Load statistics
    final statsResult = await getPlatformStatisticsUseCase();
    final statistics = statsResult.fold((l) => null, (r) => r);

    debugPrint('✅ [SuperAdminCubit] Analytics data loaded');
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
}
