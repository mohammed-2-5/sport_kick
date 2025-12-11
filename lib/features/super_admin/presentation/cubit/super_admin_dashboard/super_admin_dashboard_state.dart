import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

/// State for super admin dashboard.
///
/// Manages:
/// - Platform statistics
/// - Navigation state
/// - Quick actions
sealed class SuperAdminDashboardState extends Equatable {
  const SuperAdminDashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state.
final class SuperAdminDashboardLoading extends SuperAdminDashboardState {
  const SuperAdminDashboardLoading();
}

/// Dashboard loaded successfully.
final class SuperAdminDashboardLoaded extends SuperAdminDashboardState {
  final String adminName;
  final PlatformStatisticsEntity stats;
  final int selectedNavIndex;
  final bool isDrawerOpen;
  final bool isRefreshing;

  const SuperAdminDashboardLoaded({
    required this.adminName,
    required this.stats,
    this.selectedNavIndex = 0,
    this.isDrawerOpen = false,
    this.isRefreshing = false,
  });

  SuperAdminDashboardLoaded copyWith({
    String? adminName,
    PlatformStatisticsEntity? stats,
    int? selectedNavIndex,
    bool? isDrawerOpen,
    bool? isRefreshing,
  }) {
    return SuperAdminDashboardLoaded(
      adminName: adminName ?? this.adminName,
      stats: stats ?? this.stats,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    adminName,
    stats,
    selectedNavIndex,
    isDrawerOpen,
    isRefreshing,
  ];
}

/// Error state.
final class SuperAdminDashboardError extends SuperAdminDashboardState {
  final String message;

  const SuperAdminDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
