import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/domain/usecases/create_booking_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late CreateBookingUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CreateBookingUseCase(mockRepository);
  });

  group('CreateBookingUseCase', () {
    const tFieldId = 'field-123';
    final tDate = DateTime(2026, 1, 15); // Future date
    const tStartTime = '09:00';
    const tEndTime = '10:00';
    const tTotalPrice = 200.0;
    const tNotes = 'Please prepare the field';
    const tDurationHours = 1;

    final tBookingEntity = BookingEntity(
      id: 'booking-123',
      userId: 'user-1',
      fieldId: tFieldId,
      date: tDate,
      startTime: tStartTime,
      endTime: tEndTime,
      status: BookingStatus.pending,
      totalPrice: tTotalPrice,
      currency: 'EGP',
      createdAt: DateTime.now(),
      durationHours: tDurationHours,
      notes: tNotes,
    );

    group('successful booking creation', () {
      test(
        'should return BookingEntity when booking creation succeeds with 1 hour duration',
        () async {
          // Arrange
          when(
            () => mockRepository.createBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              notes: any(named: 'notes'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => Right(tBookingEntity));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            notes: tNotes,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBookingEntity),
            equals(tBookingEntity),
          );
          verify(
            () => mockRepository.createBooking(
              fieldId: tFieldId,
              date: tDate,
              startTime: tStartTime,
              endTime: tEndTime,
              totalPrice: tTotalPrice,
              notes: tNotes,
              durationHours: tDurationHours,
            ),
          ).called(1);
        },
      );

      test(
        'should return BookingEntity when booking creation succeeds with 2 hour duration',
        () async {
          // Arrange
          const tEndTime2Hour = '11:00';
          const tDuration2Hours = 2;
          final tBooking2Hours = tBookingEntity.copyWith(
            endTime: tEndTime2Hour,
            durationHours: tDuration2Hours,
            totalPrice: 400.0,
          );

          when(
            () => mockRepository.createBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              notes: any(named: 'notes'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => Right(tBooking2Hours));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime2Hour,
            totalPrice: 400.0,
            notes: tNotes,
            durationHours: tDuration2Hours,
          );

          // Assert
          expect(result.isRight(), true);
          expect(
            result.getOrElse(() => tBooking2Hours),
            equals(tBooking2Hours),
          );
        },
      );

      test('should succeed without notes (notes is optional)', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle cross-midnight booking (23:00 - 01:00)', () async {
        // Arrange
        const crossMidnightStart = '23:00';
        const crossMidnightEnd = '01:00';
        const duration2Hours = 2;

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: crossMidnightStart,
          endTime: crossMidnightEnd,
          totalPrice: tTotalPrice,
          durationHours: duration2Hours,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('date validation', () {
      test('should return ValidationFailure when date is today', () async {
        // Arrange
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: todayDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Bookings must be at least 1 day in advance',
          );
        }, (_) => fail('Should return failure'));
        verifyNever(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        );
      });

      test(
        'should return ValidationFailure when date is in the past',
        () async {
          // Arrange
          final pastDate = DateTime(2025, 12, 1);

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: pastDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Bookings must be at least 1 day in advance',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test('should succeed when date is tomorrow', () async {
        // Arrange
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowDate = DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
        );

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tomorrowDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed when date is far in the future', () async {
        // Arrange
        final futureDate = DateTime(2027, 12, 31);

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: futureDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('time format validation', () {
      test(
        'should return ValidationFailure when startTime format is invalid (no colon)',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '0900',
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Invalid time format',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when endTime format is invalid',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: '10:00:00',
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'Invalid time format',
            );
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return ValidationFailure when hour is invalid (>= 24)',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '25:00',
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test(
        'should return ValidationFailure when minute is invalid (>= 60)',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '09:60',
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test('should return ValidationFailure when hour is negative', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: '-1:00',
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should accept valid time at midnight (00:00)', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: '23:00',
          endTime: '00:00',
          totalPrice: tTotalPrice,
          durationHours: 1,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('duration validation', () {
      test('should return ValidationFailure when duration is 0', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: 0,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Duration must be 1 or 2 hours',
          );
        }, (_) => fail('Should return failure'));
      });

      test('should return ValidationFailure when duration is 3', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: '12:00',
          totalPrice: tTotalPrice,
          durationHours: 3,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Duration must be 1 or 2 hours',
          );
        }, (_) => fail('Should return failure'));
      });

      test(
        'should return ValidationFailure when duration is negative',
        () async {
          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: -1,
          );

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test(
        'should return ValidationFailure when end time does not match duration',
        () async {
          // Act - 1 hour duration but end time is 2 hours later
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: '09:00',
            endTime: '11:00',
            totalPrice: tTotalPrice,
            durationHours: 1,
          );

          // Assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect(
              (failure as ValidationFailure).message,
              'End time does not match duration',
            );
          }, (_) => fail('Should return failure'));
        },
      );
    });

    group('price validation', () {
      test('should return ValidationFailure when price is zero', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: 0.0,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(
            (failure as ValidationFailure).message,
            'Total price must be greater than zero',
          );
        }, (_) => fail('Should return failure'));
      });

      test('should return ValidationFailure when price is negative', () async {
        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: -100.0,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should accept small positive price', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: 0.01,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept large price', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: 10000.0,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should accept decimal price', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: 199.99,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to create booking');
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when time slot already booked',
        () async {
          // Arrange
          const tFailure = ServerFailure('Time slot is already booked');
          when(
            () => mockRepository.createBooking(
              fieldId: any(named: 'fieldId'),
              date: any(named: 'date'),
              startTime: any(named: 'startTime'),
              endTime: any(named: 'endTime'),
              totalPrice: any(named: 'totalPrice'),
              notes: any(named: 'notes'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            durationHours: tDurationHours,
          );

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return ServerFailure when field not found', () async {
        // Arrange
        const tFailure = ServerFailure('Field not found');
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: 'non-existent-field',
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          durationHours: tDurationHours,
        );

        // Assert
        verify(
          () => mockRepository.createBooking(
            fieldId: tFieldId,
            date: tDate,
            startTime: tStartTime,
            endTime: tEndTime,
            totalPrice: tTotalPrice,
            notes: null,
            durationHours: tDurationHours,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle very long notes', () async {
        // Arrange
        final longNotes = 'A' * 1000;

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          notes: longNotes,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle notes with special characters', () async {
        // Arrange
        const specialNotes = 'Please prepare field! @field#1 (premium) ⚽';

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          notes: specialNotes,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle notes with Arabic text', () async {
        // Arrange
        const arabicNotes = 'من فضلك جهز الملعب';

        when(
          () => mockRepository.createBooking(
            fieldId: any(named: 'fieldId'),
            date: any(named: 'date'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            totalPrice: any(named: 'totalPrice'),
            notes: any(named: 'notes'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => Right(tBookingEntity));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          date: tDate,
          startTime: tStartTime,
          endTime: tEndTime,
          totalPrice: tTotalPrice,
          notes: arabicNotes,
          durationHours: tDurationHours,
        );

        // Assert
        expect(result.isRight(), true);
      });
    });
  });
}
