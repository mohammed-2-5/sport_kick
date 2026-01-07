import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/recurring_bookings/domain/repositories/recurring_booking_repository.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/create_recurring_request_usecase.dart';

class MockRecurringBookingRepository extends Mock
    implements RecurringBookingRepository {}

void main() {
  late CreateRecurringRequestUseCase useCase;
  late MockRecurringBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringBookingRepository();
    useCase = CreateRecurringRequestUseCase(mockRepository);
  });

  group('CreateRecurringRequestUseCase', () {
    const tFieldId = 'field-123';
    const tDayOfWeek = 1; // Sunday
    const tStartTime = '14:00';
    const tDurationHours = 2;
    const tRecurringBookingId = 'recurring-456';

    final tParams = CreateRecurringRequestParams(
      fieldId: tFieldId,
      dayOfWeek: tDayOfWeek,
      startTime: tStartTime,
      durationHours: tDurationHours,
    );

    group('successful creation', () {
      test(
        'should return recurring booking ID when request is created',
        () async {
          // Arrange
          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Right(tRecurringBookingId));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Right(tRecurringBookingId)));
          verify(
            () => mockRepository.createRecurringRequest(
              fieldId: tFieldId,
              dayOfWeek: tDayOfWeek,
              startTime: tStartTime,
              durationHours: tDurationHours,
            ),
          ).called(1);
        },
      );

      test(
        'should use default duration of 1 hour when not specified',
        () async {
          // Arrange
          final paramsWithDefaultDuration = CreateRecurringRequestParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            startTime: tStartTime,
          );

          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Right(tRecurringBookingId));

          // Act
          await useCase(paramsWithDefaultDuration);

          // Assert
          verify(
            () => mockRepository.createRecurringRequest(
              fieldId: tFieldId,
              dayOfWeek: tDayOfWeek,
              startTime: tStartTime,
              durationHours: 1,
            ),
          ).called(1);
        },
      );

      test('should handle all days of the week', () async {
        for (int day = 0; day <= 6; day++) {
          // Arrange
          final params = CreateRecurringRequestParams(
            fieldId: tFieldId,
            dayOfWeek: day,
            startTime: tStartTime,
          );

          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => Right('recurring-$day'));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle various start times', () async {
        final times = ['06:00', '12:00', '18:00', '23:00'];

        for (final time in times) {
          // Arrange
          final params = CreateRecurringRequestParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            startTime: time,
          );

          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Right(tRecurringBookingId));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });

      test('should handle different duration hours', () async {
        final durations = [1, 2, 3, 4];

        for (final duration in durations) {
          // Arrange
          final params = CreateRecurringRequestParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            startTime: tStartTime,
            durationHours: duration,
          );

          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Right(tRecurringBookingId));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to create recurring request');
        when(
          () => mockRepository.createRecurringRequest(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            startTime: any(named: 'startTime'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.createRecurringRequest(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            startTime: any(named: 'startTime'),
            durationHours: any(named: 'durationHours'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure when slot is already reserved',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Slot is already reserved');
          when(
            () => mockRepository.createRecurringRequest(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              startTime: any(named: 'startTime'),
              durationHours: any(named: 'durationHours'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(tParams);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('CreateRecurringRequestParams', () {
      test('should support equality', () {
        final params1 = CreateRecurringRequestParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          startTime: tStartTime,
          durationHours: tDurationHours,
        );
        final params2 = CreateRecurringRequestParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          startTime: tStartTime,
          durationHours: tDurationHours,
        );

        expect(params1, equals(params2));
      });

      test('should have correct props', () {
        expect(tParams.props, [
          tFieldId,
          tDayOfWeek,
          tStartTime,
          tDurationHours,
        ]);
      });

      test('should not be equal with different values', () {
        final differentParams = CreateRecurringRequestParams(
          fieldId: 'different-field',
          dayOfWeek: tDayOfWeek,
          startTime: tStartTime,
        );

        expect(tParams, isNot(equals(differentParams)));
      });
    });
  });
}
