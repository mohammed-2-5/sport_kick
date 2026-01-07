import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/repositories/booking_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetAllBookingsUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetAllBookingsUseCase(mockRepository);
  });

  group('GetAllBookingsUseCase', () {
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
        fieldId: 'field-2',
        userId: 'user-2',
        date: tNow,
        startTime: '12:00',
        endTime: '13:00',
        totalPrice: 150.0,
        currency: 'EGP',
        status: BookingStatus.confirmed,
        createdAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return list of bookings when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getAllBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tBookings)));
        verify(() => mockRepository.getAllBookings()).called(1);
      });

      test('should return empty list when no bookings exist', () async {
        // Arrange
        when(
          () => mockRepository.getAllBookings(),
        ).thenAnswer((_) async => const Right(<BookingEntity>[]));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (bookings) => expect(bookings, isEmpty),
        );
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getAllBookings(),
        ).thenAnswer((_) async => Right(tBookings));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getAllBookings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get bookings');
        when(
          () => mockRepository.getAllBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Only super admin can view all bookings');
        when(
          () => mockRepository.getAllBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
