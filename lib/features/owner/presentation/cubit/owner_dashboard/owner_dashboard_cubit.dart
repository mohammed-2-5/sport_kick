import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/utils/locale_formatters.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_dashboard/owner_dashboard_state.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_pending_recurring_requests_usecase.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

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
  final GetPendingRecurringRequestsUseCase? _getPendingRecurringRequestsUseCase;

  OwnerDashboardCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetOwnerFieldsUseCase getOwnerFieldsUseCase,
    required GetOwnerBookingsUseCase getOwnerBookingsUseCase,
    GetPendingRecurringRequestsUseCase? getPendingRecurringRequestsUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getOwnerFieldsUseCase = getOwnerFieldsUseCase,
       _getOwnerBookingsUseCase = getOwnerBookingsUseCase,
       _getPendingRecurringRequestsUseCase = getPendingRecurringRequestsUseCase,
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

      // Fetch pending recurring count
      int pendingRecurringCount = 0;
      final pendingUseCase = _getPendingRecurringRequestsUseCase;
      if (pendingUseCase != null) {
        final recurringResult = await pendingUseCase();
        recurringResult.fold(
          (_) => pendingRecurringCount = 0,
          (requests) => pendingRecurringCount = requests.length,
        );
      }

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
                  pendingRecurringCount: pendingRecurringCount,
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
  String getGreeting([BuildContext? context]) {
    final hour = DateTime.now().hour;
    final l10n = context?.l10n;

    if (hour < 12) return l10n?.goodMorning ?? 'Good Morning';
    if (hour < 17) return l10n?.goodAfternoon ?? 'Good Afternoon';
    return l10n?.goodEvening ?? 'Good Evening';
  }

  /// Get formatted date.
  String getFormattedDate([BuildContext? context]) {
    final now = DateTime.now();
    if (context != null) {
      return LocaleFormatters.formatDate(context, now, pattern: 'EEEE, MMM d');
    }
    return DateFormat('EEEE, MMM d').format(now);
  }

  /// Format currency.
  String formatCurrency(double amount, {BuildContext? context}) {
    final currency = context?.l10n.currencyEgp ?? 'EGP';
    if (amount >= 1000000) {
      final value = context != null
          ? LocaleFormatters.formatNumber(
              context,
              amount / 1000000,
              decimalDigits: 1,
            )
          : (amount / 1000000).toStringAsFixed(1);
      return '${context?.l10n.millionsAbbreviation(value) ?? '${value}M'} $currency';
    } else if (amount >= 1000) {
      final value = context != null
          ? LocaleFormatters.formatNumber(
              context,
              amount / 1000,
              decimalDigits: 1,
            )
          : (amount / 1000).toStringAsFixed(1);
      return '${context?.l10n.thousandsAbbreviation(value) ?? '${value}K'} $currency';
    }
    if (context != null) {
      return LocaleFormatters.formatPrice(
        context,
        amount: amount,
        currency: currency,
        decimalDigits: 0,
      );
    }
    return '$currency ${amount.toStringAsFixed(0)}';
  }
}
