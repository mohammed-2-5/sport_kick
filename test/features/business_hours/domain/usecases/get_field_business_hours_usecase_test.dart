import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/usecases/get_field_business_hours_usecase.dart';

class MockBusinessHoursRepository extends Mock
    implements BusinessHoursRepository {}

void main() {
  late GetFieldBusinessHoursUseCase useCase;
  late MockBusinessHoursRepository mockRepository;

  setUp(() {
    mockRepository = MockBusinessHoursRepository();
    useCase = GetFieldBusinessHoursUseCase(mockRepository);
  });

  group('GetFieldBusinessHoursUseCase', () {
    const tFieldId = 'field-123';
    final tNow = DateTime(2026, 1, 7);

    final tBusinessHours = List.generate(
      7,
      (index) => BusinessHoursEntity(
        id: 'hours-$index',
        fieldId: tFieldId,
        dayOfWeek: index,
        isOpen: index != 5, // Closed on Friday
        openingTime: index != 5 ? '08:00:00' : null,
        closingTime: index != 5 ? '22:00:00' : null,
        createdAt: tNow,
        updatedAt: tNow,
      ),
    );

    group('successful retrieval', () {
      test('should return business hours for all 7 days', () async {
        // Arrange
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => Right(tBusinessHours));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (hours) => expect(hours.length, 7),
        );
        verify(() => mockRepository.getFieldBusinessHours(tFieldId)).called(1);
      });

      test('should return hours ordered by day of week', () async {
        // Arrange
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => Right(tBusinessHours));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        result.fold((_) => fail('Should return Right'), (hours) {
          for (int i = 0; i < 7; i++) {
            expect(hours[i].dayOfWeek, i);
          }
        });
      });

      test('should return hours with correct open/close status', () async {
        // Arrange
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => Right(tBusinessHours));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        result.fold((_) => fail('Should return Right'), (hours) {
          expect(hours[5].isOpen, false); // Friday closed
          expect(hours[0].isOpen, true); // Sunday open
        });
      });

      test('should return empty list for field with no hours set', () async {
        // Arrange
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (hours) => expect(hours, isEmpty),
        );
      });

      test('should return 24/7 hours for field open all day', () async {
        // Arrange
        final hours24_7 = List.generate(
          7,
          (index) => BusinessHoursEntity(
            id: 'hours-$index',
            fieldId: tFieldId,
            dayOfWeek: index,
            isOpen: true,
            openingTime: '00:00:00',
            closingTime: '23:59:59',
            createdAt: tNow,
            updatedAt: tNow,
          ),
        );

        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => Right(hours24_7));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        result.fold((_) => fail('Should return Right'), (hours) {
          for (final hour in hours) {
            expect(hour.isOpen24Hours, true);
          }
        });
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get business hours');
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase('non-existent-field');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getFieldBusinessHours(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
