import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_dashboard/super_admin_dashboard_state.dart';

/// Cubit for super admin dashboard.
///
/// Manages:
/// - Platform statistics loading
/// - Navigation state
/// - Quick actions
/// - Data refresh
class SuperAdminDashboardCubit extends Cubit<SuperAdminDashboardState> {
  final GetPlatformStatisticsUseCase _getPlatformStatisticsUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SuperAdminDashboardCubit({
    required GetPlatformStatisticsUseCase getPlatformStatisticsUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _getPlatformStatisticsUseCase = getPlatformStatisticsUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const SuperAdminDashboardLoading());

  /// Loads dashboard data.
  Future<void> loadDashboard() async {
    emit(const SuperAdminDashboardLoading());

    try {
      // Get current user for admin name
      final userResult = await _getCurrentUserUseCase();
      final adminName = userResult.fold(
        (_) => 'Admin',
        (user) => user?.fullName ?? user?.email ?? 'Admin',
      );

      // Get platform statistics
      final statsResult = await _getPlatformStatisticsUseCase();

      statsResult.fold(
        (failure) => emit(SuperAdminDashboardError(failure.message)),
        (stats) =>
            emit(SuperAdminDashboardLoaded(adminName: adminName, stats: stats)),
      );
    } catch (e) {
      emit(SuperAdminDashboardError(e.toString()));
    }
  }

  /// Refreshes dashboard data.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      emit(currentState.copyWith(isRefreshing: true));

      try {
        // Get updated statistics
        final statsResult = await _getPlatformStatisticsUseCase();

        statsResult.fold(
          (failure) => emit(currentState.copyWith(isRefreshing: false)),
          (stats) =>
              emit(currentState.copyWith(stats: stats, isRefreshing: false)),
        );
      } catch (e) {
        emit(currentState.copyWith(isRefreshing: false));
      }
    }
  }

  /// Changes the navigation index.
  void changeNavIndex(int index) {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      emit(currentState.copyWith(selectedNavIndex: index));
    }
  }

  /// Toggles drawer state.
  void toggleDrawer(bool isOpen) {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      emit(currentState.copyWith(isDrawerOpen: isOpen));
    }
  }

  /// Gets greeting based on time of day.
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Gets formatted current date.
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d').format(DateTime.now());
  }

  /// Formats currency value.
  String formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M SAR';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K SAR';
    }
    return '${value.toStringAsFixed(0)} SAR';
  }

  /// Formats number with suffix.
  String formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Gets user growth percentage from loaded state.
  double getUserGrowthPercentage() {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      return currentState.stats.userGrowthRate;
    }
    return 0.0;
  }

  /// Gets booking growth percentage from loaded state.
  double getBookingGrowthPercentage() {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      return currentState.stats.bookingGrowthRate;
    }
    return 0.0;
  }

  /// Gets revenue growth percentage from loaded state.
  double getRevenueGrowthPercentage() {
    final currentState = state;
    if (currentState is SuperAdminDashboardLoaded) {
      return currentState.stats.revenueGrowthRate;
    }
    return 0.0;
  }
}
