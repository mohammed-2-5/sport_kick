import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_state.dart';

import '../../../domain/usecases/get_owner_fields_usecase.dart';

/// Cubit for managing owner dashboard state.
///
/// Handles:
/// - Loading dashboard data
/// - Navigation state
/// - Refresh operations
/// - Stats calculations
class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetOwnerFieldsUseCase _getOwnerFieldsUseCase;
  final GetOwnerBookingsUseCase _getOwnerBookingsUseCase;

  OwnerDashboardCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetOwnerFieldsUseCase getOwnerFieldsUseCase,
    required GetOwnerBookingsUseCase getOwnerBookingsUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getOwnerFieldsUseCase = getOwnerFieldsUseCase,
       _getOwnerBookingsUseCase = getOwnerBookingsUseCase,
       super(const OwnerDashboardLoading());

  /// Load all dashboard data.
  Future<void> loadDashboard() async {
    emit(const OwnerDashboardLoading());

    try {
      // Get current user
      final userResult = await _getCurrentUserUseCase();
      String ownerName = 'Owner';
      String ownerId = '';

      userResult.fold((failure) => null, (user) {
        ownerName = user?.displayName ?? 'Owner';
        ownerId = user?.id ?? '';
      });

      if (ownerId.isEmpty) {
        emit(const OwnerDashboardError('Unable to load owner data'));
        return;
      }

      // Load fields and bookings in parallel
      final fieldsResult = await _getOwnerFieldsUseCase(ownerId: ownerId);
      final bookingsResult = await _getOwnerBookingsUseCase();

      fieldsResult.fold(
        (failure) => emit(OwnerDashboardError(failure.message)),
        (fields) {
          bookingsResult.fold(
            (failure) => emit(OwnerDashboardError(failure.message)),
            (bookings) {
              final recentBookings = bookings.take(5).toList();
              final stats = OwnerDashboardStats.fromData(fields, bookings);

              emit(
                OwnerDashboardLoaded(
                  ownerName: ownerName,
                  fields: fields,
                  recentBookings: recentBookings,
                  stats: stats,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(OwnerDashboardError(e.toString()));
    }
  }

  /// Refresh dashboard data.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is OwnerDashboardLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    await loadDashboard();
  }

  /// Change navigation index.
  void changeNavIndex(int index) {
    final currentState = state;
    if (currentState is OwnerDashboardLoaded) {
      emit(currentState.copyWith(selectedNavIndex: index));
    }
  }

  /// Toggle drawer.
  void toggleDrawer() {
    final currentState = state;
    if (currentState is OwnerDashboardLoaded) {
      emit(currentState.copyWith(isDrawerOpen: !currentState.isDrawerOpen));
    }
  }

  /// Open drawer.
  void openDrawer() {
    final currentState = state;
    if (currentState is OwnerDashboardLoaded) {
      emit(currentState.copyWith(isDrawerOpen: true));
    }
  }

  /// Close drawer.
  void closeDrawer() {
    final currentState = state;
    if (currentState is OwnerDashboardLoaded) {
      emit(currentState.copyWith(isDrawerOpen: false));
    }
  }

  /// Get greeting based on time of day.
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

  /// Get formatted date.
  String getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  /// Format currency.
  String formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M EGP';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K EGP';
    }
    return '${amount.toStringAsFixed(0)} EGP';
  }
}
