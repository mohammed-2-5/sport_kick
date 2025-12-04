import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/exceptions.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/data/models/booking_model.dart';
import 'package:spo_kick/features/bookings/data/models/time_slot_model.dart';
import 'package:spo_kick/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late BookingRepositoryImpl repository;
  late MockBookingRemoteDataSource mockRemoteDataSource;

  final now = DateTime.now();

  // Test Data
  final tBookingModel = BookingModel(
    id: 'booking-1',
    userId: 'user-1',
    fieldId: 'field-1',
    date: now,
    startTime: '10:00',
    endTime: '11:00',
    status: BookingStatus.confirmed,
    totalPrice: 100.0,
    currency: 'EGP',
    createdAt: now,
  );

  final BookingEntity tBookingEntity = tBookingModel;
  final List<BookingModel> tBookingModels = [tBookingModel];
  final List<BookingEntity> tBookingEntities = [tBookingEntity];

  const tTimeSlotModel = TimeSlotModel(
    startTime: '10:00',
    endTime: '11:00',
    isAvailable: true,
    price: 100.0,
    currency: 'EGP',
  );

  const TimeSlotEntity tTimeSlotEntity = tTimeSlotModel;
  final List<TimeSlotModel> tTimeSlotModels = [tTimeSlotModel];
  final List<TimeSlotEntity> tTimeSlotEntities = [tTimeSlotEntity];

  setUp(() {
    mockRemoteDataSource = MockBookingRemoteDataSource();
    repository = BookingRepositoryImpl(remoteDataSource: mockRemoteDataSource);

    // Register fallback values
    registerFallbackValue(tBookingModel);
    registerFallbackValue(BookingStatus.pending);
  });

  group('BookingRepositoryImpl -', () {
    group('getUserBookings -', () {
      test(
        'should return list of bookings when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getUserBookings(any()),
          ).thenAnswer((_) async => tBookingModels);

          // Act
          final result = await repository.getUserBookings();

          // Assert
          verify(() => mockRemoteDataSource.getUserBookings(any())).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookingEntities));
        },
      );

      test(
        'should return ServerFailure when remote data source throws ServerException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getUserBookings(any()),
          ).thenThrow(const ServerException('Server Error'));

          // Act
          final result = await repository.getUserBookings();

          // Assert
          verify(() => mockRemoteDataSource.getUserBookings(any())).called(1);
          expect(result, equals(const Left(ServerFailure('Server Error'))));
        },
      );
    });

    group('getBookingById -', () {
      const tBookingId = 'booking-1';

      test(
        'should return booking when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getBookingById(tBookingId),
          ).thenAnswer((_) async => tBookingModel);

          // Act
          final result = await repository.getBookingById(tBookingId);

          // Assert
          verify(
            () => mockRemoteDataSource.getBookingById(tBookingId),
          ).called(1);
          expect(result, equals(Right(tBookingEntity)));
        },
      );

      test(
        'should return NotFoundFailure when remote data source throws NotFoundException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getBookingById(tBookingId),
          ).thenThrow(const NotFoundException('Booking not found'));

          // Act
          final result = await repository.getBookingById(tBookingId);

          // Assert
          verify(
            () => mockRemoteDataSource.getBookingById(tBookingId),
          ).called(1);
          expect(result, equals(const Left(NotFoundFailure('Booking not found'))));
        },
      );
    });

    group('getAvailableTimeSlots -', () {
      const tFieldId = 'field-1';

      test(
        'should return list of time slots when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAvailableTimeSlots(
              fieldId: tFieldId,
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => tTimeSlotModels);

          // Act
          final result = await repository.getAvailableTimeSlots(
            fieldId: tFieldId,
            date: now,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.getAvailableTimeSlots(
              fieldId: tFieldId,
              date: now,
            ),
          ).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tTimeSlotEntities));
        },
      );
    });

    group('createBooking -', () {
      test(
        'should return created booking when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createBooking(any()),
          ).thenAnswer((_) async => tBookingModel);

          // Act
          final result = await repository.createBooking(
            fieldId: 'field-1',
            date: now,
            startTime: '10:00',
            endTime: '11:00',
            totalPrice: 100.0,
          );

          // Assert
          verify(() => mockRemoteDataSource.createBooking(any())).called(1);
          expect(result, equals(Right(tBookingEntity)));
        },
      );

      test(
        'should return ConflictFailure when remote data source throws ConflictException',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createBooking(any()),
          ).thenThrow(const ConflictException('Slot taken'));

          // Act
          final result = await repository.createBooking(
            fieldId: 'field-1',
            date: now,
            startTime: '10:00',
            endTime: '11:00',
            totalPrice: 100.0,
          );

          // Assert
          verify(() => mockRemoteDataSource.createBooking(any())).called(1);
          expect(result, equals(const Left(ConflictFailure('Slot taken'))));
        },
      );
    });

    group('cancelBooking -', () {
      const tBookingId = 'booking-1';
      const tReason = 'Changed mind';

      test(
        'should return canceled booking when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.cancelBooking(tBookingId, tReason),
          ).thenAnswer((_) async => tBookingModel);

          // Act
          final result = await repository.cancelBooking(
            bookingId: tBookingId,
            reason: tReason,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.cancelBooking(tBookingId, tReason),
          ).called(1);
          expect(result, equals(Right(tBookingEntity)));
        },
      );
    });

    group('updateBookingStatus -', () {
      const tBookingId = 'booking-1';
      const tStatus = BookingStatus.confirmed;

      test(
        'should return updated booking when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.updateBookingStatus(tBookingId, tStatus),
          ).thenAnswer((_) async => tBookingModel);

          // Act
          final result = await repository.updateBookingStatus(
            bookingId: tBookingId,
            status: tStatus,
          );

          // Assert
          verify(
            () => mockRemoteDataSource.updateBookingStatus(tBookingId, tStatus),
          ).called(1);
          expect(result, equals(Right(tBookingEntity)));
        },
      );
    });

    group('getBookingsByStatus -', () {
      const tStatus = BookingStatus.confirmed;

      test(
        'should return list of bookings when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getBookingsByStatus(any(), tStatus),
          ).thenAnswer((_) async => tBookingModels);

          // Act
          final result = await repository.getBookingsByStatus(status: tStatus);

          // Assert
          verify(
            () => mockRemoteDataSource.getBookingsByStatus(any(), tStatus),
          ).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookingEntities));
        },
      );
    });

    group('getOwnerBookings -', () {
      test(
        'should return list of bookings when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getOwnerBookings(),
          ).thenAnswer((_) async => tBookingModels);

          // Act
          final result = await repository.getOwnerBookings();

          // Assert
          verify(() => mockRemoteDataSource.getOwnerBookings()).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookingEntities));
        },
      );
    });

    group('getAllBookings -', () {
      test(
        'should return list of bookings when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAllBookings(),
          ).thenAnswer((_) async => tBookingModels);

          // Act
          final result = await repository.getAllBookings();

          // Assert
          verify(() => mockRemoteDataSource.getAllBookings()).called(1);
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tBookingEntities));
        },
      );
    });

    group('createManualBooking -', () {
      test(
        'should return created booking when remote data source is successful',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.createManualBooking(any()),
          ).thenAnswer((_) async => tBookingModel);

          // Act
          final result = await repository.createManualBooking(
            fieldId: 'field-1',
            date: now,
            startTime: '10:00',
            endTime: '11:00',
            totalPrice: 100.0,
            customerName: 'John Doe',
            customerPhone: '1234567890',
          );

          // Assert
          verify(
            () => mockRemoteDataSource.createManualBooking(any()),
          ).called(1);
          expect(result, equals(Right(tBookingEntity)));
        },
      );
    });
  });
}
