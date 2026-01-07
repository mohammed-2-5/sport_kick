import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_active_recurring_bookings_for_owner_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late GetActiveRecurringBookingsForOwnerUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = GetActiveRecurringBookingsForOwnerUseCase(mockRepository);
  });

  group('GetActiveRecurringBookingsForOwnerUseCase', () {
    final tActiveBookings = [
      RecurringBookingEntity(
        id: 'active-1',
        fieldId: 'field-1',
        fieldName: 'Field A',
        dayOfWeek: 1,
        startTime: '14:00',
        endTime: '16:00',
        durationHours: 2,
        pricePerBooking: 150.0,
        status: RecurringBookingStatus.active,
        startedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        userId: 'user-1',
        userName: 'Ahmed Hassan',
        totalBookingsCount: 4,
        completedBookingsCount: 1,
      ),
      RecurringBookingEntity(
        id: 'active-2',
        fieldId: 'field-2',
        fieldName: 'Field B',
        dayOfWeek: 3,
        startTime: '18:00',
        endTime: '19:00',
        durationHours: 1,
        pricePerBooking: 100.0,
        status: RecurringBookingStatus.active,
        startedAt: DateTime(2025, 12, 15),
        createdAt: DateTime(2025, 12, 15),
        userId: 'user-2',
        userName: 'Mohamed Ali',
        totalBookingsCount: 8,
        completedBookingsCount: 4,
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return list of active bookings when call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getActiveRecurringBookingsForOwner(),
          ).thenAnswer((_) async => Right(tActiveBookings));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(Right(tActiveBookings)));
          verify(
            () => mockRepository.getActiveRecurringBookingsForOwner(),
          ).called(1);
        },
      );

      test('should return empty list when no active bookings exist', () async {
        // Arrange
        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (bookings) => expect(bookings, isEmpty),
        );
      });

      test('should return only active status bookings', () async {
        // Arrange
        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => Right(tActiveBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          for (final booking in bookings) {
            expect(booking.status, RecurringBookingStatus.active);
            expect(booking.isActive, true);
          }
        });
      });

      test('should return bookings with subscriber information', () async {
        // Arrange
        final bookingWithUserInfo = [
          RecurringBookingEntity(
            id: 'active-1',
            fieldId: 'field-1',
            fieldName: 'Premium Field',
            dayOfWeek: 5,
            startTime: '18:00',
            endTime: '20:00',
            durationHours: 2,
            pricePerBooking: 300.0,
            status: RecurringBookingStatus.active,
            startedAt: DateTime(2026, 1, 1),
            createdAt: DateTime(2026, 1, 1),
            userId: 'user-1',
            userName: 'Premium Customer',
            userEmail: 'premium@example.com',
            userPhone: '+201234567890',
            userAvatarUrl: 'https://example.com/avatar.jpg',
            nextBookingDate: DateTime(2026, 1, 8),
            nextBookingPaid: true,
            totalBookingsCount: 4,
            completedBookingsCount: 1,
          ),
        ];

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => Right(bookingWithUserInfo));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          final booking = bookings.first;
          expect(booking.userId, 'user-1');
          expect(booking.userName, 'Premium Customer');
          expect(booking.userEmail, isNotNull);
          expect(booking.userPhone, isNotNull);
          expect(booking.nextBookingDate, isNotNull);
          expect(booking.remainingBookingsCount, 3);
        });
      });

      test('should return bookings for multiple fields owned', () async {
        // Arrange
        final multiFieldBookings = [
          RecurringBookingEntity(
            id: 'active-1',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: 0,
            startTime: '10:00',
            endTime: '12:00',
            durationHours: 2,
            pricePerBooking: 100.0,
            status: RecurringBookingStatus.active,
            createdAt: DateTime(2026, 1, 1),
          ),
          RecurringBookingEntity(
            id: 'active-2',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: 2,
            startTime: '14:00',
            endTime: '16:00',
            durationHours: 2,
            pricePerBooking: 100.0,
            status: RecurringBookingStatus.active,
            createdAt: DateTime(2026, 1, 1),
          ),
          RecurringBookingEntity(
            id: 'active-3',
            fieldId: 'field-2',
            fieldName: 'Field B',
            dayOfWeek: 4,
            startTime: '18:00',
            endTime: '20:00',
            durationHours: 2,
            pricePerBooking: 150.0,
            status: RecurringBookingStatus.active,
            createdAt: DateTime(2026, 1, 1),
          ),
        ];

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => Right(multiFieldBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          expect(bookings.length, 3);
          expect(bookings.where((b) => b.fieldId == 'field-1').length, 2);
          expect(bookings.where((b) => b.fieldId == 'field-2').length, 1);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => Right(tActiveBookings));

        // Act
        await useCase();

        // Assert
        verify(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return bookings with payment status', () async {
        // Arrange
        final bookingsWithPayment = [
          RecurringBookingEntity(
            id: 'active-1',
            fieldId: 'field-1',
            fieldName: 'Field A',
            dayOfWeek: 1,
            startTime: '14:00',
            endTime: '16:00',
            durationHours: 2,
            pricePerBooking: 150.0,
            status: RecurringBookingStatus.active,
            createdAt: DateTime(2026, 1, 1),
            nextBookingDate: DateTime(2026, 1, 8),
            nextBookingPaid: false,
          ),
          RecurringBookingEntity(
            id: 'active-2',
            fieldId: 'field-2',
            fieldName: 'Field B',
            dayOfWeek: 3,
            startTime: '18:00',
            endTime: '19:00',
            durationHours: 1,
            pricePerBooking: 100.0,
            status: RecurringBookingStatus.active,
            createdAt: DateTime(2026, 1, 1),
            nextBookingDate: DateTime(2026, 1, 10),
            nextBookingPaid: true,
          ),
        ];

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => Right(bookingsWithPayment));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          expect(bookings[0].needsPayment, true);
          expect(bookings[1].needsPayment, false);
        });
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch active bookings');

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when owner not authenticated', () async {
        // Arrange
        const tFailure = AuthFailure('Owner not authenticated');

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user is not an owner', () async {
        // Arrange
        const tFailure = AuthFailure('User is not a field owner');

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.getActiveRecurringBookingsForOwner(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
