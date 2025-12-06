import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/domain/usecases/approve_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/delete_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/reject_booking_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';

/// Cubit for managing owner (field owner/admin) operations
class OwnerCubit extends Cubit<OwnerState> {
  final GetOwnerFieldsUseCase getOwnerFieldsUseCase;
  final UpdateFieldUseCase updateFieldUseCase;
  final GetOwnerBookingsUseCase getOwnerBookingsUseCase;
  final ApproveBookingUseCase approveBookingUseCase;
  final RejectBookingUseCase rejectBookingUseCase;
  final GetOwnerRevenueUseCase getOwnerRevenueUseCase;
  final UpdateOwnerProfileUseCase updateOwnerProfileUseCase;
  final DeleteFieldUseCase deleteFieldUseCase;

  OwnerCubit({
    required this.getOwnerFieldsUseCase,
    required this.updateFieldUseCase,
    required this.getOwnerBookingsUseCase,
    required this.approveBookingUseCase,
    required this.rejectBookingUseCase,
    required this.getOwnerRevenueUseCase,
    required this.updateOwnerProfileUseCase,
    required this.deleteFieldUseCase,
  }) : super(const OwnerInitial());

  /// Load all dashboard data (fields, bookings, revenue) in parallel
  /// This is the single entry point for the dashboard page
  Future<void> loadDashboardData(String ownerId) async {
    debugPrint('🔄 [OwnerCubit] Loading dashboard data for owner: $ownerId');
    emit(const OwnerLoading(message: 'Loading dashboard...'));

    // Load all data
    final fieldsResult = await getOwnerFieldsUseCase(ownerId: ownerId);
    final bookingsResult = await getOwnerBookingsUseCase(ownerId: ownerId);
    final revenueResult = await getOwnerRevenueUseCase(ownerId: ownerId);

    // Check for any errors
    String? errorMessage;
    fieldsResult.fold((f) => errorMessage = f.message, (_) {});
    if (errorMessage == null) {
      bookingsResult.fold((f) => errorMessage = f.message, (_) {});
    }
    if (errorMessage == null) {
      revenueResult.fold((f) => errorMessage = f.message, (_) {});
    }

    if (errorMessage != null) {
      debugPrint('❌ [OwnerCubit] Error loading dashboard: $errorMessage');
      emit(OwnerError(errorMessage!));
      return;
    }

    // All succeeded - emit combined state
    final fields = fieldsResult.getOrElse(() => []);
    final bookings = bookingsResult.getOrElse(() => []);
    final revenue = revenueResult.fold((_) => null, (r) => r);

    debugPrint(
      '✅ [OwnerCubit] Dashboard data loaded: ${fields.length} fields, ${bookings.length} bookings',
    );
    emit(OwnerDataLoaded(fields: fields, bookings: bookings, revenue: revenue));
  }

  /// Load all fields owned by the owner
  Future<void> loadOwnerFields(String ownerId) async {
    debugPrint('🔄 [OwnerCubit] Loading fields for owner: $ownerId');
    emit(const OwnerLoading(message: 'Loading your fields...'));

    final result = await getOwnerFieldsUseCase(ownerId: ownerId);

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error loading fields: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (fields) {
        debugPrint('✅ [OwnerCubit] Loaded ${fields.length} fields');
        // Preserve existing data
        final currentState = state;
        if (currentState is OwnerDataLoaded) {
          emit(currentState.copyWith(fields: fields));
        } else {
          emit(OwnerDataLoaded(fields: fields));
        }
      },
    );
  }

  /// Update field details
  Future<void> updateField(String fieldId, Map<String, dynamic> updates) async {
    debugPrint('🔄 [OwnerCubit] Updating field: $fieldId');
    emit(const OwnerLoading(message: 'Updating field...'));

    final result = await updateFieldUseCase(fieldId: fieldId, updates: updates);

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error updating field: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (field) {
        debugPrint('✅ [OwnerCubit] Field updated successfully');
        emit(const OwnerActionSuccess('Field updated successfully'));
      },
    );
  }

  /// Delete a field
  Future<void> deleteField(String fieldId) async {
    debugPrint('🔄 [OwnerCubit] Deleting field: $fieldId');
    emit(const OwnerLoading(message: 'Deleting field...'));

    final result = await deleteFieldUseCase(fieldId);

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error deleting field: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerCubit] Field deleted successfully');
        emit(const OwnerActionSuccess('Field deleted successfully'));
      },
    );
  }

  /// Load all bookings for owner's fields
  Future<void> loadOwnerBookings({
    required String ownerId,
    String? status,
  }) async {
    debugPrint('🔄 [OwnerCubit] Loading bookings for owner: $ownerId');
    emit(const OwnerLoading(message: 'Loading bookings...'));

    final result = await getOwnerBookingsUseCase(
      ownerId: ownerId,
      status: status,
    );

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error loading bookings: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (bookings) {
        debugPrint('✅ [OwnerCubit] Loaded ${bookings.length} bookings');
        // Preserve existing data
        final currentState = state;
        if (currentState is OwnerDataLoaded) {
          emit(currentState.copyWith(bookings: bookings));
        } else {
          emit(OwnerDataLoaded(bookings: bookings));
        }
      },
    );
  }

  /// Approve a pending booking
  Future<void> approveBooking(String bookingId) async {
    debugPrint('🔄 [OwnerCubit] Approving booking: $bookingId');
    emit(const OwnerLoading(message: 'Approving booking...'));

    final result = await approveBookingUseCase(bookingId: bookingId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerCubit] Error approving booking: ${failure.message}',
        );
        emit(OwnerError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerCubit] Booking approved successfully');
        emit(const OwnerActionSuccess('Booking approved successfully'));
      },
    );
  }

  /// Reject a booking with a reason
  Future<void> rejectBooking(String bookingId, String reason) async {
    debugPrint('🔄 [OwnerCubit] Rejecting booking: $bookingId');
    emit(const OwnerLoading(message: 'Rejecting booking...'));

    final result = await rejectBookingUseCase(
      bookingId: bookingId,
      reason: reason,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerCubit] Error rejecting booking: ${failure.message}',
        );
        emit(OwnerError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerCubit] Booking rejected successfully');
        emit(const OwnerActionSuccess('Booking rejected successfully'));
      },
    );
  }

  /// Load revenue statistics for owner
  Future<void> loadOwnerRevenue(String ownerId) async {
    debugPrint('🔄 [OwnerCubit] Loading revenue for owner: $ownerId');
    emit(const OwnerLoading(message: 'Loading revenue data...'));

    final result = await getOwnerRevenueUseCase(ownerId: ownerId);

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error loading revenue: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (revenue) {
        debugPrint('✅ [OwnerCubit] Revenue loaded successfully');
        // Preserve existing data
        final currentState = state;
        if (currentState is OwnerDataLoaded) {
          emit(currentState.copyWith(revenue: revenue));
        } else {
          emit(OwnerDataLoaded(revenue: revenue));
        }
      },
    );
  }

  /// Update owner profile information
  Future<void> updateProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  }) async {
    debugPrint('🔄 [OwnerCubit] Updating profile for owner: $ownerId');
    emit(const OwnerLoading(message: 'Updating profile...'));

    final result = await updateOwnerProfileUseCase(
      ownerId: ownerId,
      fullName: fullName,
      phone: phone,
    );

    result.fold(
      (failure) {
        debugPrint('❌ [OwnerCubit] Error updating profile: ${failure.message}');
        emit(OwnerError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerCubit] Profile updated successfully');
        emit(const OwnerActionSuccess('Profile updated successfully'));
      },
    );
  }

  /// Reset to initial state
  void reset() {
    debugPrint('🔄 [OwnerCubit] Resetting state');
    emit(const OwnerInitial());
  }
}
