import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_state.dart';

/// Cubit for managing owner profile state.
///
/// Handles:
/// - Loading profile statistics (fields, bookings, revenue)
/// - Refreshing profile data
class OwnerProfileCubit extends Cubit<OwnerProfileState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetOwnerFieldsUseCase _getOwnerFieldsUseCase;
  final GetOwnerBookingsUseCase _getOwnerBookingsUseCase;
  final GetOwnerRevenueUseCase _getOwnerRevenueUseCase;

  OwnerProfileCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetOwnerFieldsUseCase getOwnerFieldsUseCase,
    required GetOwnerBookingsUseCase getOwnerBookingsUseCase,
    required GetOwnerRevenueUseCase getOwnerRevenueUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase,
       _getOwnerFieldsUseCase = getOwnerFieldsUseCase,
       _getOwnerBookingsUseCase = getOwnerBookingsUseCase,
       _getOwnerRevenueUseCase = getOwnerRevenueUseCase,
       super(const OwnerProfileInitial());

  /// Load profile data.
  Future<void> loadProfile() async {
    emit(const OwnerProfileLoading());

    // Get current user
    final userResult = await _getCurrentUserUseCase();
    final ownerId = userResult.fold((_) => null, (user) => user?.id);

    if (ownerId == null) {
      emit(const OwnerProfileError('User not authenticated'));
      return;
    }

    // Load all data in parallel
    final results = await Future.wait([
      _getOwnerFieldsUseCase(ownerId: ownerId),
      _getOwnerBookingsUseCase(ownerId: ownerId),
      _getOwnerRevenueUseCase(ownerId: ownerId),
    ]);

    // Extract results
    final fieldsResult = results[0];
    final bookingsResult = results[1];
    final revenueResult = results[2];

    // Check for errors
    if (fieldsResult.isLeft() || bookingsResult.isLeft()) {
      emit(const OwnerProfileError('Failed to load profile data'));
      return;
    }

    // Extract data
    final fieldsCount = fieldsResult.fold(
      (_) => 0,
      (r) => (r as List<FieldEntity>).length,
    );

    final bookingsCount = bookingsResult.fold(
      (_) => 0,
      (r) => (r as List<BookingEntity>).length,
    );

    final revenue = revenueResult.fold(
      (_) => null as OwnerRevenueEntity?,
      (r) => r as OwnerRevenueEntity,
    );

    emit(
      OwnerProfileLoaded(
        fieldsCount: fieldsCount,
        bookingsCount: bookingsCount,
        revenue: revenue,
      ),
    );
  }

  /// Refresh profile data.
  Future<void> refresh() async {
    if (state is! OwnerProfileLoaded) {
      return loadProfile();
    }

    final currentState = state as OwnerProfileLoaded;
    emit(currentState.copyWith(isRefreshing: true));

    // Get current user
    final userResult = await _getCurrentUserUseCase();
    final ownerId = userResult.fold((_) => null, (user) => user?.id);

    if (ownerId == null) {
      emit(const OwnerProfileError('User not authenticated'));
      return;
    }

    // Load all data in parallel
    final results = await Future.wait([
      _getOwnerFieldsUseCase(ownerId: ownerId),
      _getOwnerBookingsUseCase(ownerId: ownerId),
      _getOwnerRevenueUseCase(ownerId: ownerId),
    ]);

    // Extract results
    final fieldsResult = results[0];
    final bookingsResult = results[1];
    final revenueResult = results[2];

    // Extract data
    final fieldsCount = fieldsResult.fold(
      (_) => currentState.fieldsCount,
      (r) => (r as List<FieldEntity>).length,
    );

    final bookingsCount = bookingsResult.fold(
      (_) => currentState.bookingsCount,
      (r) => (r as List<BookingEntity>).length,
    );

    final revenue = revenueResult.fold(
      (_) => currentState.revenue,
      (r) => r as OwnerRevenueEntity,
    );

    emit(
      OwnerProfileLoaded(
        fieldsCount: fieldsCount,
        bookingsCount: bookingsCount,
        revenue: revenue,
        isRefreshing: false,
      ),
    );
  }
}
