import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/data/datasources/owner_remote_datasource.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';

/// Implementation of [OwnerRepository]
class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<FieldEntity>>> getOwnerFields(
    String ownerId,
  ) async {
    try {
      debugPrint('📦 [OwnerRepository] Getting fields for owner: $ownerId');
      final fields = await remoteDataSource.getOwnerFields(ownerId);
      return Right(fields);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to get fields: $e'));
    }
  }

  @override
  Future<Either<Failure, FieldEntity>> updateField(
    String fieldId,
    Map<String, dynamic> updates,
  ) async {
    try {
      debugPrint('📦 [OwnerRepository] Updating field: $fieldId');
      final field = await remoteDataSource.updateField(fieldId, updates);
      return Right(field);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to update field: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getOwnerBookings({
    required String ownerId,
    String? status,
  }) async {
    try {
      debugPrint('📦 [OwnerRepository] Getting bookings for owner: $ownerId');
      final bookings = await remoteDataSource.getOwnerBookings(
        ownerId: ownerId,
        status: status,
      );
      return Right(bookings);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to get bookings: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> approveBooking(String bookingId) async {
    try {
      debugPrint('📦 [OwnerRepository] Approving booking: $bookingId');
      await remoteDataSource.approveBooking(bookingId);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to approve booking: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectBooking(
    String bookingId,
    String reason,
  ) async {
    try {
      debugPrint('📦 [OwnerRepository] Rejecting booking: $bookingId');
      await remoteDataSource.rejectBooking(bookingId, reason);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to reject booking: $e'));
    }
  }

  @override
  Future<Either<Failure, OwnerRevenueEntity>> getOwnerRevenue(
    String ownerId,
  ) async {
    try {
      debugPrint('📦 [OwnerRepository] Getting revenue for owner: $ownerId');
      final data = await remoteDataSource.getOwnerRevenue(ownerId);

      final revenue = OwnerRevenueEntity(
        totalRevenue: data['total_revenue'] as double,
        monthlyRevenue: data['monthly_revenue'] as double,
        totalBookings: data['total_bookings'] as int,
        monthlyBookings: data['monthly_bookings'] as int,
        pendingBookings: data['pending_bookings'] as int,
        revenueByField: Map<String, double>.from(
          data['revenue_by_field'] as Map,
        ),
      );

      return Right(revenue);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to get revenue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOwnerProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  }) async {
    try {
      debugPrint('📦 [OwnerRepository] Updating profile for owner: $ownerId');
      await remoteDataSource.updateOwnerProfile(
        ownerId: ownerId,
        fullName: fullName,
        phone: phone,
      );
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteField(String fieldId) async {
    try {
      debugPrint('📦 [OwnerRepository] Deleting field: $fieldId');
      await remoteDataSource.deleteField(fieldId);
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('❌ [OwnerRepository] Server error: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      debugPrint('❌ [OwnerRepository] Unexpected error: $e');
      return Left(ServerFailure('Failed to delete field: $e'));
    }
  }
}
