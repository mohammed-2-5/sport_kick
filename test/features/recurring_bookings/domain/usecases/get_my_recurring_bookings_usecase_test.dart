import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_my_recurring_bookings_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late GetMyRecurringBookingsUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = GetMyRecurringBookingsUseCase(mockRepository);
  });

  group('GetMyRecurringBookingsUseCase', () {
    final tRecurringBookings = [
      RecurringBookingEntity(
        id: 'recurring-1',
        fieldId: 'field-1',
        fieldName: 'Field A',
        dayOfWeek: 1,
        startTime: '14:00',
        endTime: '16:00',
        durationHours: 2,
        pricePerBooking: 150.0,
        status: RecurringBookingStatus.active,
        createdAt: DateTime(2026, 1, 1),
      ),
      RecurringBookingEntity(
        id: 'recurring-2',
        fieldId: 'field-2',
        fieldName: 'Field B',
        dayOfWeek: 3,
        startTime: '18:00',
        endTime: '19:00',
        durationHours: 1,
        pricePerBooking: 100.0,
        status: RecurringBookingStatus.pendingApproval,
        createdAt: DateTime(2026, 1, 2),
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return list of recurring bookings when call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getMyRecurringBookings(),
          ).thenAnswer((_) async => Right(tRecurringBookings));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(Right(tRecurringBookings)));
          verify(() => mockRepository.getMyRecurringBookings()).called(1);
        },
      );

      test(
        'should return empty list when user has no recurring bookings',
        () async {
          // Arrange
          when(
            () => mockRepository.getMyRecurringBookings(),
          ).thenAnswer((_) async => const Right([]));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Should return Right'),
            (bookings) => expect(bookings, isEmpty),
          );
        },
      );

      test('should return bookings with all statuses', () async {
        // Arrange
        final mixedStatusBookings = [
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
          ),
          RecurringBookingEntity(
            id: 'pending-1',
            fieldId: 'field-2',
            fieldName: 'Field B',
            dayOfWeek: 2,
            startTime: '10:00',
            endTime: '11:00',
            durationHours: 1,
            pricePerBooking: 100.0,
            status: RecurringBookingStatus.pendingApproval,
            createdAt: DateTime(2026, 1, 2),
          ),
          RecurringBookingEntity(
            id: 'canceled-1',
            fieldId: 'field-3',
            fieldName: 'Field C',
            dayOfWeek: 3,
            startTime: '16:00',
            endTime: '18:00',
            durationHours: 2,
            pricePerBooking: 200.0,
            status: RecurringBookingStatus.canceled,
            createdAt: DateTime(2026, 1, 3),
          ),
          RecurringBookingEntity(
            id: 'rejected-1',
            fieldId: 'field-4',
            fieldName: 'Field D',
            dayOfWeek: 4,
            startTime: '20:00',
            endTime: '22:00',
            durationHours: 2,
            pricePerBooking: 250.0,
            status: RecurringBookingStatus.rejected,
            rejectionReason: 'Slot not available',
            createdAt: DateTime(2026, 1, 4),
          ),
        ];

        when(
          () => mockRepository.getMyRecurringBookings(),
        ).thenAnswer((_) async => Right(mixedStatusBookings));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          expect(bookings.length, 4);
          expect(bookings.where((b) => b.isActive).length, 1);
          expect(bookings.where((b) => b.isPending).length, 1);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getMyRecurringBookings(),
        ).thenAnswer((_) async => Right(tRecurringBookings));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getMyRecurringBookings()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should return bookings with complete field information', () async {
        // Arrange
        final bookingWithFullInfo = [
          RecurringBookingEntity(
            id: 'recurring-1',
            fieldId: 'field-1',
            fieldName: 'Premium Field',
            fieldImageUrl: 'https://example.com/field.jpg',
            cityName: 'Cairo',
            dayOfWeek: 5,
            startTime: '18:00',
            endTime: '20:00',
            durationHours: 2,
            pricePerBooking: 300.0,
            status: RecurringBookingStatus.active,
            startedAt: DateTime(2026, 1, 1),
            createdAt: DateTime(2026, 1, 1),
            nextBookingDate: DateTime(2026, 1, 8),
            nextBookingPaid: false,
            totalBookingsCount: 4,
            completedBookingsCount: 1,
          ),
        ];

        when(
          () => mockRepository.getMyRecurringBookings(),
        ).thenAnswer((_) async => Right(bookingWithFullInfo));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (bookings) {
          final booking = bookings.first;
          expect(booking.fieldName, 'Premium Field');
          expect(booking.fieldImageUrl, isNotNull);
          expect(booking.cityName, 'Cairo');
          expect(booking.needsPayment, true);
          expect(booking.remainingBookingsCount, 3);
        });
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch recurring bookings');

        when(
          () => mockRepository.getMyRecurringBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when user not authenticated', () async {
        // Arrange
        const tFailure = AuthFailure('User not authenticated');

        when(
          () => mockRepository.getMyRecurringBookings(),
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
          () => mockRepository.getMyRecurringBookings(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
