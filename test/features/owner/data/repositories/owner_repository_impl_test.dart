import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/fields/data/models/field_model.dart';
import 'package:spo_kick/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late OwnerRepositoryImpl repository;
  late MockOwnerRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOwnerRemoteDataSource();
    repository = OwnerRepositoryImpl(mockRemoteDataSource);
  });

  group('OwnerRepositoryImpl', () {
    const tOwnerId = 'owner-123';
    const tFieldId = 'field-123';
    const tBookingId = 'booking-123';

    final tFieldModel = FieldModel(
      id: tFieldId,
      name: 'Test Field',
      sportCategoryId: 'sport-1',
      ownerId: tOwnerId,
      city: 'Cairo',
      address: '123 Test St',
      pricePerHour: 100.0,
      currency: 'EGP',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tBookingModel = BookingModel(
      id: tBookingId,
      userId: 'user-123',
      fieldId: tFieldId,
      date: DateTime.now(),
      startTime: '10:00',
      endTime: '11:00',
      status: BookingStatus.pending,
      totalPrice: 100.0,
      currency: 'EGP',
      createdAt: DateTime.now(),
    );

    final tRevenueData = {
      'total_revenue': 5000.0,
      'monthly_revenue': 1500.0,
      'total_bookings': 50,
      'monthly_bookings': 15,
      'pending_bookings': 5,
      'revenue_by_field': {'field-1': 2000.0, 'field-2': 3000.0},
    };

    const tRevenueEntity = OwnerRevenueEntity(
      totalRevenue: 5000.0,
      monthlyRevenue: 1500.0,
      totalBookings: 50,
      monthlyBookings: 15,
      pendingBookings: 5,
      revenueByField: {'field-1': 2000.0, 'field-2': 3000.0},
    );

    group('getOwnerFields', () {
      test(
        'should return List<FieldEntity> when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerFields(tOwnerId),
          ).thenAnswer((_) async => [tFieldModel]);

          // Act
          final result = await repository.getOwnerFields(tOwnerId);

          // Assert
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals([tFieldModel]));
          verify(() => mockRemoteDataSource.getOwnerFields(tOwnerId)).called(1);
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerFields(tOwnerId),
          ).thenThrow(const ServerException('Server error'));

          // Act
          final result = await repository.getOwnerFields(tOwnerId);

          // Assert
          expect(result, equals(const Left(ServerFailure('Server error'))));
          verify(() => mockRemoteDataSource.getOwnerFields(tOwnerId)).called(1);
        },
      );
    });

    group('updateField', () {
      final tUpdates = {'name': 'Updated Field', 'pricePerHour': 150.0};

      test('should return FieldEntity when update is successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateField(tFieldId, tUpdates),
        ).thenAnswer((_) async => tFieldModel);

        // Act
        final result = await repository.updateField(tFieldId, tUpdates);

        // Assert
        expect(result, equals(Right(tFieldModel)));
        verify(
          () => mockRemoteDataSource.updateField(tFieldId, tUpdates),
        ).called(1);
      });

      test(
        'should return ServerFailure when update throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.updateField(tFieldId, tUpdates),
          ).thenThrow(const ServerException('Update failed'));

          // Act
          final result = await repository.updateField(tFieldId, tUpdates);

          // Assert
          expect(result, equals(const Left(ServerFailure('Update failed'))));
          verify(
            () => mockRemoteDataSource.updateField(tFieldId, tUpdates),
          ).called(1);
        },
      );
    });

    group('getOwnerBookings', () {
      test(
        'should return List<BookingEntity> when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerBookings(
              ownerId: tOwnerId,
              status: null,
            ),
          ).thenAnswer((_) async => [tBookingModel]);

          // Act
          final result = await repository.getOwnerBookings(ownerId: tOwnerId);

          // Assert
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals([tBookingModel]));
          verify(
            () => mockRemoteDataSource.getOwnerBookings(
              ownerId: tOwnerId,
              status: null,
            ),
          ).called(1);
        },
      );

      test('should return filtered bookings when status is provided', () async {
        // Arrange
        const tStatus = 'pending';
        when(
          () => mockRemoteDataSource.getOwnerBookings(
            ownerId: tOwnerId,
            status: tStatus,
          ),
        ).thenAnswer((_) async => [tBookingModel]);

        // Act
        final result = await repository.getOwnerBookings(
          ownerId: tOwnerId,
          status: tStatus,
        );

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), equals([tBookingModel]));
        verify(
          () => mockRemoteDataSource.getOwnerBookings(
            ownerId: tOwnerId,
            status: tStatus,
          ),
        ).called(1);
      });

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerBookings(
              ownerId: tOwnerId,
              status: null,
            ),
          ).thenThrow(const ServerException('Failed to get bookings'));

          // Act
          final result = await repository.getOwnerBookings(ownerId: tOwnerId);

          // Assert
          expect(
            result,
            equals(const Left(ServerFailure('Failed to get bookings'))),
          );
          verify(
            () => mockRemoteDataSource.getOwnerBookings(
              ownerId: tOwnerId,
              status: null,
            ),
          ).called(1);
        },
      );
    });

    group('approveBooking', () {
      test('should return Right(null) when approval is successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.approveBooking(tBookingId),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.approveBooking(tBookingId);

        // Assert
        expect(result, equals(const Right(null)));
        verify(() => mockRemoteDataSource.approveBooking(tBookingId)).called(1);
      });

      test(
        'should return ServerFailure when approval throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.approveBooking(tBookingId),
          ).thenThrow(const ServerException('Approval failed'));

          // Act
          final result = await repository.approveBooking(tBookingId);

          // Assert
          expect(result, equals(const Left(ServerFailure('Approval failed'))));
          verify(
            () => mockRemoteDataSource.approveBooking(tBookingId),
          ).called(1);
        },
      );
    });

    group('rejectBooking', () {
      const tReason = 'Field unavailable';

      test('should return Right(null) when rejection is successful', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.rejectBooking(tBookingId, tReason),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.rejectBooking(tBookingId, tReason);

        // Assert
        expect(result, equals(const Right(null)));
        verify(
          () => mockRemoteDataSource.rejectBooking(tBookingId, tReason),
        ).called(1);
      });

      test(
        'should return ServerFailure when rejection throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.rejectBooking(tBookingId, tReason),
          ).thenThrow(const ServerException('Rejection failed'));

          // Act
          final result = await repository.rejectBooking(tBookingId, tReason);

          // Assert
          expect(result, equals(const Left(ServerFailure('Rejection failed'))));
          verify(
            () => mockRemoteDataSource.rejectBooking(tBookingId, tReason),
          ).called(1);
        },
      );
    });

    group('getOwnerRevenue', () {
      test(
        'should return OwnerRevenueEntity when remote call is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerRevenue(tOwnerId),
          ).thenAnswer((_) async => tRevenueData);

          // Act
          final result = await repository.getOwnerRevenue(tOwnerId);

          // Assert
          expect(result, equals(const Right(tRevenueEntity)));
          verify(
            () => mockRemoteDataSource.getOwnerRevenue(tOwnerId),
          ).called(1);
        },
      );

      test(
        'should return ServerFailure when remote call throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerRevenue(tOwnerId),
          ).thenThrow(const ServerException('Failed to get revenue'));

          // Act
          final result = await repository.getOwnerRevenue(tOwnerId);

          // Assert
          expect(
            result,
            equals(const Left(ServerFailure('Failed to get revenue'))),
          );
          verify(
            () => mockRemoteDataSource.getOwnerRevenue(tOwnerId),
          ).called(1);
        },
      );
    });

    group('updateOwnerProfile', () {
      const tFullName = 'Updated Name';
      const tPhone = '+201234567890';

      test(
        'should return Right(null) when profile update is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.updateOwnerProfile(
              ownerId: tOwnerId,
              fullName: tFullName,
              phone: tPhone,
            ),
          ).thenAnswer((_) async => {});

          // Act
          final result = await repository.updateOwnerProfile(
            ownerId: tOwnerId,
            fullName: tFullName,
            phone: tPhone,
          );

          // Assert
          expect(result, equals(const Right(null)));
          verify(
            () => mockRemoteDataSource.updateOwnerProfile(
              ownerId: tOwnerId,
              fullName: tFullName,
              phone: tPhone,
            ),
          ).called(1);
        },
      );

      test(
        'should return ServerFailure when update throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.updateOwnerProfile(
              ownerId: tOwnerId,
              fullName: tFullName,
              phone: null,
            ),
          ).thenThrow(const ServerException('Update failed'));

          // Act
          final result = await repository.updateOwnerProfile(
            ownerId: tOwnerId,
            fullName: tFullName,
          );

          // Assert
          expect(result, equals(const Left(ServerFailure('Update failed'))));
          verify(
            () => mockRemoteDataSource.updateOwnerProfile(
              ownerId: tOwnerId,
              fullName: tFullName,
              phone: null,
            ),
          ).called(1);
        },
      );
    });
  });
}
