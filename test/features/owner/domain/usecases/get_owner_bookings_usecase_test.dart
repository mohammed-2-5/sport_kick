import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_bookings_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late GetOwnerBookingsUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = GetOwnerBookingsUseCase(mockRepository);
  });

  group('GetOwnerBookingsUseCase', () {
    const tOwnerId = 'owner-123';
    final tNow = DateTime(2026, 1, 7);
    final tBookings = <BookingEntity>[
      BookingEntity(
        id: 'booking-1',
        fieldId: 'field-1',
        userId: 'user-1',
        date: tNow,
        startTime: '10:00',
        endTime: '11:00',
        totalPrice: 100.0,
        currency: 'EGP',
        status: BookingStatus.pending,
        createdAt: tNow,
      ),
      BookingEntity(
        id: 'booking-2',
        fieldId: 'field-1',
        userId: 'user-2',
        date: tNow,
        startTime: '12:00',
        endTime: '13:00',
        totalPrice: 100.0,
        currency: 'EGP',
        status: BookingStatus.confirmed,
        createdAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return list of bookings when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(Right(tBookings)));
      });

      test('should return empty list when no bookings exist', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (bookings) => expect(bookings, isEmpty),
        );
      });

      test('should filter bookings by status', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right([tBookings[0]]));

        // Act
        final result = await useCase(ownerId: tOwnerId, status: 'pending');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getOwnerBookings(
            ownerId: tOwnerId,
            status: 'pending',
          ),
        ).called(1);
      });

      test('should return all bookings without status filter', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () =>
              mockRepository.getOwnerBookings(ownerId: tOwnerId, status: null),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        await useCase(ownerId: tOwnerId);

        // Assert
        verify(
          () =>
              mockRepository.getOwnerBookings(ownerId: tOwnerId, status: null),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get bookings');
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to view these bookings');
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getOwnerBookings(
            ownerId: any(named: 'ownerId'),
            status: any(named: 'status'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
