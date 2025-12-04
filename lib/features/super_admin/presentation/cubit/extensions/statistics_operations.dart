import 'package:flutter/foundation.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// Extension for platform statistics operations.
///
/// Handles loading and displaying platform-wide statistics.
extension StatisticsOperations on SuperAdminCubit {
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
}
