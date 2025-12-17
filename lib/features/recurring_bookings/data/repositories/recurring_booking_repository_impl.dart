import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/data/datasources/recurring_booking_remote_datasource.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';

/// Implementation of recurring booking repository.
class RecurringBookingRepositoryImpl implements RecurringBookingRepository {
  final RecurringBookingRemoteDataSource _remoteDataSource;

  RecurringBookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> createRecurringRequest({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
    required int durationHours,
  }) async {
    try {
      final result = await _remoteDataSource.createRecurringRequest(
        fieldId: fieldId,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        durationHours: durationHours,
      );
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Create request error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelRecurringBooking({
    required String recurringBookingId,
    String? reason,
  }) async {
    try {
      final result = await _remoteDataSource.cancelRecurringBooking(
        recurringBookingId: recurringBookingId,
        reason: reason,
      );
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Cancel error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getMyRecurringBookings() async {
    try {
      final result = await _remoteDataSource.getMyRecurringBookings();
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Get my bookings error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> approveRecurringBooking({
    required String recurringBookingId,
  }) async {
    try {
      final result = await _remoteDataSource.approveRecurringBooking(
        recurringBookingId: recurringBookingId,
      );
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Approve error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectRecurringBooking({
    required String recurringBookingId,
    required String reason,
  }) async {
    try {
      final result = await _remoteDataSource.rejectRecurringBooking(
        recurringBookingId: recurringBookingId,
        reason: reason,
      );
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Reject error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getPendingRecurringRequests() async {
    try {
      final result = await _remoteDataSource.getPendingRecurringRequests();
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Get pending requests error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<RecurringBookingEntity>>>
  getActiveRecurringBookingsForOwner() async {
    try {
      final result = await _remoteDataSource
          .getActiveRecurringBookingsForOwner();
      return Right(result.map((m) => m.toEntity()).toList());
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Get active for owner error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isSlotReserved({
    required String fieldId,
    required int dayOfWeek,
    required String startTime,
  }) async {
    try {
      final result = await _remoteDataSource.isSlotReserved(
        fieldId: fieldId,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
      );
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Check reserved slot error: $e');
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, List<ReservedSlot>>> getReservedSlots({
    required String fieldId,
  }) async {
    try {
      final result = await _remoteDataSource.getReservedSlots(fieldId: fieldId);
      return Right(result);
    } catch (e) {
      debugPrint('❌ [RecurringBookingRepo] Get reserved slots error: $e');
      return Left(_mapError(e));
    }
  }

  /// Map exception to failure.
  Failure _mapError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('slot already has')) {
      return const ServerFailure(
        'This time slot is already reserved by another recurring booking.',
      );
    }

    if (errorStr.contains('outside business hours')) {
      return const ServerFailure(
        'The selected time is outside the field\'s business hours.',
      );
    }

    if (errorStr.contains('not found or inactive')) {
      return const ServerFailure('Field not found or is currently inactive.');
    }

    if (errorStr.contains('not authorized')) {
      return const ServerFailure(
        'You are not authorized to perform this action.',
      );
    }

    if (errorStr.contains('can only cancel active')) {
      return const ServerFailure('Only active subscriptions can be canceled.');
    }

    if (errorStr.contains('not pending')) {
      return const ServerFailure('This request is no longer pending approval.');
    }

    return ServerFailure('An error occurred: ${error.toString()}');
  }
}
