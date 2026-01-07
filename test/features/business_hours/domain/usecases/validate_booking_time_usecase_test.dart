import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/validate_booking_time_usecase.dart';

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late ValidateBookingTimeUseCase useCase;
  late MockBusinessHoursRepository mockRepository;

  setUp(() {
    mockRepository = MockBusinessHoursRepository();
    useCase = ValidateBookingTimeUseCase(mockRepository);
  });

  group('ValidateBookingTimeUseCase', () {
    const tFieldId = 'field-123';
    final tFutureTime = DateTime.now().add(const Duration(days: 1));

    group('successful validation', () {
      test(
        'should return true when booking time is within business hours',
        () async {
          // Arrange
          final params = ValidateBookingTimeParams(
            fieldId: tFieldId,
            bookingTime: tFutureTime,
          );

          when(
            () => mockRepository.validateBookingTime(
              fieldId: any(named: 'fieldId'),
              bookingTime: any(named: 'bookingTime'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Right(true)));
          verify(
            () => mockRepository.validateBookingTime(
              fieldId: tFieldId,
              bookingTime: tFutureTime,
            ),
          ).called(1);
        },
      );

      test(
        'should return false when booking time is outside business hours',
        () async {
          // Arrange
          final params = ValidateBookingTimeParams(
            fieldId: tFieldId,
            bookingTime: tFutureTime,
          );

          when(
            () => mockRepository.validateBookingTime(
              fieldId: any(named: 'fieldId'),
              bookingTime: any(named: 'bookingTime'),
            ),
          ).thenAnswer((_) async => const Right(false));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Right(false)));
        },
      );

      test(
        'should return false for past booking times without calling repository',
        () async {
          // Arrange
          final pastTime = DateTime.now().subtract(const Duration(hours: 1));
          final params = ValidateBookingTimeParams(
            fieldId: tFieldId,
            bookingTime: pastTime,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Right(false)));
          verifyNever(
            () => mockRepository.validateBookingTime(
              fieldId: any(named: 'fieldId'),
              bookingTime: any(named: 'bookingTime'),
            ),
          );
        },
      );

      test('should handle various future booking times', () async {
        final futureTimes = [
          DateTime.now().add(const Duration(hours: 1)),
          DateTime.now().add(const Duration(days: 7)),
          DateTime.now().add(const Duration(days: 30)),
        ];

        for (final time in futureTimes) {
          // Arrange
          final params = ValidateBookingTimeParams(
            fieldId: tFieldId,
            bookingTime: time,
          );

          when(
            () => mockRepository.validateBookingTime(
              fieldId: any(named: 'fieldId'),
              bookingTime: any(named: 'bookingTime'),
            ),
          ).thenAnswer((_) async => const Right(true));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when field ID is empty', () async {
        // Arrange
        final params = ValidateBookingTimeParams(
          fieldId: '',
          bookingTime: tFutureTime,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Field ID cannot be empty'))),
        );
        verifyNever(
          () => mockRepository.validateBookingTime(
            fieldId: any(named: 'fieldId'),
            bookingTime: any(named: 'bookingTime'),
          ),
        );
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        final params = ValidateBookingTimeParams(
          fieldId: tFieldId,
          bookingTime: tFutureTime,
        );
        const tFailure = ServerFailure('Failed to validate booking time');

        when(
          () => mockRepository.validateBookingTime(
            fieldId: any(named: 'fieldId'),
            bookingTime: any(named: 'bookingTime'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        final params = ValidateBookingTimeParams(
          fieldId: 'non-existent-field',
          bookingTime: tFutureTime,
        );
        const tFailure = ValidationFailure('Field not found');

        when(
          () => mockRepository.validateBookingTime(
            fieldId: any(named: 'fieldId'),
            bookingTime: any(named: 'bookingTime'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        final params = ValidateBookingTimeParams(
          fieldId: tFieldId,
          bookingTime: tFutureTime,
        );
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.validateBookingTime(
            fieldId: any(named: 'fieldId'),
            bookingTime: any(named: 'bookingTime'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
