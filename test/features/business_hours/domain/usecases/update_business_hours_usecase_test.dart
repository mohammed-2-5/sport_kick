import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/update_business_hours_usecase.dart';

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late UpdateBusinessHoursUseCase useCase;
  late MockBusinessHoursRepository mockRepository;

  setUp(() {
    mockRepository = MockBusinessHoursRepository();
    useCase = UpdateBusinessHoursUseCase(mockRepository);
  });

  group('UpdateBusinessHoursUseCase', () {
    const tFieldId = 'field-123';
    const tDayOfWeek = 1; // Monday
    const tOpeningTime = '08:00:00';
    const tClosingTime = '22:00:00';
    final tNow = DateTime(2026, 1, 7);

    final tUpdatedHours = BusinessHoursEntity(
      id: 'hours-1',
      fieldId: tFieldId,
      dayOfWeek: tDayOfWeek,
      isOpen: true,
      openingTime: tOpeningTime,
      closingTime: tClosingTime,
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful update', () {
      test('should return updated hours when update succeeds', () async {
        // Arrange
        const params = UpdateBusinessHoursParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: true,
          openingTime: tOpeningTime,
          closingTime: tClosingTime,
        );

        when(
          () => mockRepository.updateBusinessHours(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            isOpen: any(named: 'isOpen'),
            openingTime: any(named: 'openingTime'),
            closingTime: any(named: 'closingTime'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedHours));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(Right(tUpdatedHours)));
      });

      test('should update to closed successfully', () async {
        // Arrange
        const params = UpdateBusinessHoursParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: false,
        );

        final closedHours = BusinessHoursEntity(
          id: 'hours-1',
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: false,
          createdAt: tNow,
          updatedAt: tNow,
        );

        when(
          () => mockRepository.updateBusinessHours(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            isOpen: any(named: 'isOpen'),
            openingTime: any(named: 'openingTime'),
            closingTime: any(named: 'closingTime'),
          ),
        ).thenAnswer((_) async => Right(closedHours));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (hours) => expect(hours.isOpen, false),
        );
      });

      test('should handle all days of the week', () async {
        for (int day = 0; day <= 6; day++) {
          // Arrange
          final params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: day,
            isOpen: true,
            openingTime: tOpeningTime,
            closingTime: tClosingTime,
          );

          final hoursForDay = BusinessHoursEntity(
            id: 'hours-$day',
            fieldId: tFieldId,
            dayOfWeek: day,
            isOpen: true,
            openingTime: tOpeningTime,
            closingTime: tClosingTime,
            createdAt: tNow,
            updatedAt: tNow,
          );

          when(
            () => mockRepository.updateBusinessHours(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              isOpen: any(named: 'isOpen'),
              openingTime: any(named: 'openingTime'),
              closingTime: any(named: 'closingTime'),
            ),
          ).thenAnswer((_) async => Right(hoursForDay));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        }
      });
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure for invalid day of week (< 0)',
        () async {
          // Arrange
          const params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: -1,
            isOpen: true,
            openingTime: tOpeningTime,
            closingTime: tClosingTime,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(const Left(ValidationFailure('Invalid day of week'))),
          );
          verifyNever(
            () => mockRepository.updateBusinessHours(
              fieldId: any(named: 'fieldId'),
              dayOfWeek: any(named: 'dayOfWeek'),
              isOpen: any(named: 'isOpen'),
              openingTime: any(named: 'openingTime'),
              closingTime: any(named: 'closingTime'),
            ),
          );
        },
      );

      test(
        'should return ValidationFailure for invalid day of week (> 6)',
        () async {
          // Arrange
          const params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: 7,
            isOpen: true,
            openingTime: tOpeningTime,
            closingTime: tClosingTime,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(const Left(ValidationFailure('Invalid day of week'))),
          );
        },
      );

      test(
        'should return ValidationFailure when open without opening time',
        () async {
          // Arrange
          const params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            isOpen: true,
            closingTime: tClosingTime,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure(
                  'Opening and closing times required when open',
                ),
              ),
            ),
          );
        },
      );

      test(
        'should return ValidationFailure when open without closing time',
        () async {
          // Arrange
          const params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            isOpen: true,
            openingTime: tOpeningTime,
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure(
                  'Opening and closing times required when open',
                ),
              ),
            ),
          );
        },
      );

      test('should return ValidationFailure for invalid time format', () async {
        // Arrange
        const params = UpdateBusinessHoursParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: true,
          openingTime: '8:00', // Invalid format
          closingTime: tClosingTime,
        );

        // Act
        final result = await useCase(params);

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Invalid time format'))),
        );
      });

      test(
        'should return ValidationFailure when closing before opening',
        () async {
          // Arrange
          const params = UpdateBusinessHoursParams(
            fieldId: tFieldId,
            dayOfWeek: tDayOfWeek,
            isOpen: true,
            openingTime: '22:00:00',
            closingTime: '08:00:00',
          );

          // Act
          final result = await useCase(params);

          // Assert
          expect(
            result,
            equals(
              const Left(
                ValidationFailure('Opening time must be before closing time'),
              ),
            ),
          );
        },
      );
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const params = UpdateBusinessHoursParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: true,
          openingTime: tOpeningTime,
          closingTime: tClosingTime,
        );
        const tFailure = ServerFailure('Failed to update business hours');

        when(
          () => mockRepository.updateBusinessHours(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            isOpen: any(named: 'isOpen'),
            openingTime: any(named: 'openingTime'),
            closingTime: any(named: 'closingTime'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const params = UpdateBusinessHoursParams(
          fieldId: tFieldId,
          dayOfWeek: tDayOfWeek,
          isOpen: true,
          openingTime: tOpeningTime,
          closingTime: tClosingTime,
        );
        const tFailure = NetworkFailure('No internet connection');

        when(
          () => mockRepository.updateBusinessHours(
            fieldId: any(named: 'fieldId'),
            dayOfWeek: any(named: 'dayOfWeek'),
            isOpen: any(named: 'isOpen'),
            openingTime: any(named: 'openingTime'),
            closingTime: any(named: 'closingTime'),
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
