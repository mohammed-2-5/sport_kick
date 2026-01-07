import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/domain/usecases/get_available_time_slots_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetAvailableTimeSlotsUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetAvailableTimeSlotsUseCase(mockRepository);
  });

  group('GetAvailableTimeSlotsUseCase', () {
    const tFieldId = 'field-123';
    final tDate = DateTime(2026, 1, 15); // Future date

    final tTimeSlots = [
      const TimeSlotEntity(
        startTime: '09:00',
        endTime: '10:00',
        isAvailable: true,
        price: 200.0,
        currency: 'EGP',
      ),
      const TimeSlotEntity(
        startTime: '10:00',
        endTime: '11:00',
        isAvailable: false,
        price: 200.0,
        currency: 'EGP',
      ),
      const TimeSlotEntity(
        startTime: '11:00',
        endTime: '12:00',
        isAvailable: true,
        price: 200.0,
        currency: 'EGP',
      ),
    ];

    group('successful retrieval', () {
      test(
        'should return List<TimeSlotEntity> when repository call succeeds',
        () async {
          // Arrange
          when(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => Right(tTimeSlots));

          // Act
          final result = await useCase(fieldId: tFieldId, date: tDate);

          // Assert
          expect(result.isRight(), true);
          expect(result.getOrElse(() => []), equals(tTimeSlots));
          verify(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: tFieldId,
              date: tDate,
            ),
          ).called(1);
        },
      );

      test('should return empty list when no time slots available', () async {
        // Arrange
        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), isEmpty);
      });

      test(
        'should return time slots with mix of available and unavailable',
        () async {
          // Arrange
          final mixedSlots = [
            const TimeSlotEntity(
              startTime: '09:00',
              endTime: '10:00',
              isAvailable: true,
              price: 200.0,
              currency: 'EGP',
            ),
            const TimeSlotEntity(
              startTime: '10:00',
              endTime: '11:00',
              isAvailable: false,
              price: 200.0,
              currency: 'EGP',
            ),
          ];

          when(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => Right(mixedSlots));

          // Act
          final result = await useCase(fieldId: tFieldId, date: tDate);

          // Assert
          expect(result.isRight(), true);
          final slots = result.getOrElse(() => []);
          expect(slots.length, equals(2));
          expect(slots[0].isAvailable, true);
          expect(slots[1].isAvailable, false);
        },
      );

      test('should return time slots with cross-midnight times', () async {
        // Arrange
        final crossMidnightSlots = [
          const TimeSlotEntity(
            startTime: '23:00',
            endTime: '00:00',
            isAvailable: true,
            price: 300.0,
            currency: 'EGP',
            isNextDay: true,
          ),
        ];

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(crossMidnightSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        final slots = result.getOrElse(() => []);
        expect(slots[0].isNextDay, true);
      });

      test('should return time slots with different prices', () async {
        // Arrange
        final variablePriceSlots = [
          const TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 150.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '18:00',
            endTime: '19:00',
            isAvailable: true,
            price: 250.0,
            currency: 'EGP',
          ),
        ];

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(variablePriceSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        final slots = result.getOrElse(() => []);
        expect(slots[0].price, 150.0);
        expect(slots[1].price, 250.0);
      });
    });

    group('date validation', () {
      test(
        'should return ValidationFailure when date is in the past',
        () async {
          // Arrange
          final pastDate = DateTime(2025, 12, 1);

          // Act
          final result = await useCase(fieldId: tFieldId, date: pastDate);

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Cannot view slots for past dates',
            );
          }, (_) => fail('Should return failure'));
          verifyNever(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          );
        },
      );

      test('should succeed when date is today', () async {
        // Arrange
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(tTimeSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: todayDate);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed when date is tomorrow', () async {
        // Arrange
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowDate = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
        );

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(tTimeSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tomorrowDate);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed when date is far in the future', () async {
        // Arrange
        final futureDate = DateTime(2027, 12, 31);

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(tTimeSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: futureDate);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get time slots');
        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when field not found', () async {
        // Arrange
        const tFailure = ServerFailure('Field not found');
        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: 'non-existent-field',
          date: tDate,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when field has no business hours',
        () async {
          // Arrange
          const tFailure = ServerFailure(
            'Field has no business hours configured',
          );
          when(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(fieldId: tFieldId, date: tDate);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ServerFailure when field is closed on selected date',
        () async {
          // Arrange
          const tFailure = ServerFailure('Field is closed on this date');
          when(
            () => mockRepository.getAvailableTimeSlots(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(fieldId: tFieldId, date: tDate);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('edge cases', () {
      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(tTimeSlots));

        // Act
        await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        verify(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: tFieldId,
            date: tDate,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle large number of time slots', () async {
        // Arrange
        final largeSlotList = List.generate(
          100,
          (index) => TimeSlotEntity(
            startTime: '${index.toString().padLeft(2, '0')}:00',
            endTime: '${(index + 1).toString().padLeft(2, '0')}:00',
            isAvailable: index % 2 == 0,
            price: 200.0,
            currency: 'EGP',
          ),
        );

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(largeSlotList));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []).length, equals(100));
      });

      test('should handle field ID with special characters', () async {
        // Arrange
        const specialFieldId = 'field-123_456-xyz';

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(tTimeSlots));

        // Act
        final result = await useCase(fieldId: specialFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: specialFieldId,
            date: tDate,
          ),
        ).called(1);
      });

      test('should handle time slots with all slots booked', () async {
        // Arrange
        final allBookedSlots = [
          const TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: false,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: false,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(allBookedSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        final slots = result.getOrElse(() => []);
        expect(slots.every((slot) => !slot.isAvailable), true);
      });

      test('should handle time slots with all slots available', () async {
        // Arrange
        final allAvailableSlots = [
          const TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(allAvailableSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        final slots = result.getOrElse(() => []);
        expect(slots.every((slot) => slot.isAvailable), true);
      });

      test('should preserve time slot order from repository', () async {
        // Arrange
        final orderedSlots = [
          const TimeSlotEntity(
            startTime: '08:00',
            endTime: '09:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '09:00',
            endTime: '10:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
          const TimeSlotEntity(
            startTime: '10:00',
            endTime: '11:00',
            isAvailable: true,
            price: 200.0,
            currency: 'EGP',
          ),
        ];

        when(
          () => mockRepository.getAvailableTimeSlots(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right(orderedSlots));

        // Act
        final result = await useCase(fieldId: tFieldId, date: tDate);

        // Assert
        expect(result.isRight(), true);
        final slots = result.getOrElse(() => []);
        expect(slots[0].startTime, '08:00');
        expect(slots[1].startTime, '09:00');
        expect(slots[2].startTime, '10:00');
      });
    });
  });
}
