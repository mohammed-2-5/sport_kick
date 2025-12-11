import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/bookings/domain/usecases/update_booking_status_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_bookings/owner_bookings_state.dart';

/// Cubit for managing owner bookings page.
///
/// Handles:
/// - Loading bookings
/// - Filtering by status
/// - Search functionality
/// - Tab switching
/// - Approve/Reject actions
class OwnerBookingsCubit extends Cubit<OwnerBookingsState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetOwnerBookingsUseCase _getOwnerBookingsUseCase;
  final UpdateBookingStatusUseCase _updateBookingStatusUseCase;

  OwnerBookingsCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetOwnerBookingsUseCase getOwnerBookingsUseCase,
    required UpdateBookingStatusUseCase updateBookingStatusUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getOwnerBookingsUseCase = getOwnerBookingsUseCase,
       _updateBookingStatusUseCase = updateBookingStatusUseCase,
       super(const OwnerBookingsLoading());

  /// Load all bookings.
  Future<void> loadBookings() async {
    emit(const OwnerBookingsLoading());

    try {
      // Get current user
      final userResult = await _getCurrentUserUseCase();
      String ownerId = '';

      userResult.fold((failure) => null, (user) => ownerId = user?.id ?? '');

      if (ownerId.isEmpty) {
        emit(const OwnerBookingsError('Unable to load owner data'));
        return;
      }

      // Load bookings
      final result = await _getOwnerBookingsUseCase();

      result.fold(
        (failure) => emit(OwnerBookingsError(failure.message)),
        (bookings) => emit(OwnerBookingsLoaded(allBookings: bookings)),
      );
    } catch (e) {
      emit(OwnerBookingsError(e.toString()));
    }
  }

  /// Refresh bookings.
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is OwnerBookingsLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    await loadBookings();
  }

  /// Change tab index.
  void changeTab(int index) {
    final currentState = state;
    if (currentState is OwnerBookingsLoaded) {
      BookingStatus? filter;
      switch (index) {
        case 0:
          filter = null; // All
          break;
        case 1:
          filter = BookingStatus.pending;
          break;
        case 2:
          filter = BookingStatus.confirmed;
          break;
        case 3:
          filter = BookingStatus.canceled;
          break;
      }

      emit(
        currentState.copyWith(
          selectedTabIndex: index,
          selectedFilter: filter,
          clearFilter: filter == null,
        ),
      );
    }
  }

  /// Update search query.
  void search(String query) {
    final currentState = state;
    if (currentState is OwnerBookingsLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  /// Clear search.
  void clearSearch() {
    final currentState = state;
    if (currentState is OwnerBookingsLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }

  /// Approve booking.
  Future<void> approveBooking(String bookingId) async {
    final result = await _updateBookingStatusUseCase(
      bookingId: bookingId,
      status: BookingStatus.confirmed,
    );

    result.fold((failure) => emit(OwnerBookingsError(failure.message)), (
      _,
    ) async {
      // Reload bookings after successful update
      await loadBookings();
    });
  }

  /// Reject booking.
  Future<void> rejectBooking(String bookingId) async {
    final result = await _updateBookingStatusUseCase(
      bookingId: bookingId,
      status: BookingStatus.canceled,
    );

    result.fold((failure) => emit(OwnerBookingsError(failure.message)), (
      _,
    ) async {
      // Reload bookings after successful update
      await loadBookings();
    });
  }

  /// Get stats for the current filter.
  Map<String, int> getStats() {
    final currentState = state;
    if (currentState is! OwnerBookingsLoaded) {
      return {
        'total': 0,
        'pending': 0,
        'confirmed': 0,
        'canceled': 0,
        'completed': 0,
      };
    }

    return {
      'total': currentState.allBookings.length,
      'pending': currentState.getCountByStatus(BookingStatus.pending),
      'confirmed': currentState.getCountByStatus(BookingStatus.confirmed),
      'canceled': currentState.getCountByStatus(BookingStatus.canceled),
      'completed': currentState.getCountByStatus(BookingStatus.completed),
    };
  }
}
