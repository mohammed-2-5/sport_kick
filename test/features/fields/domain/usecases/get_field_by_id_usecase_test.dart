import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_field_by_id_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late GetFieldByIdUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = GetFieldByIdUseCase(mockRepository);
  });

  group('GetFieldByIdUseCase', () {
    const tFieldId = 'field-123';
    final tNow = DateTime(2026, 1, 1);
    final tField = FieldEntity(
      id: tFieldId,
      ownerId: 'owner-1',
      sportCategoryId: 'football',
      name: 'Premium Stadium',
      description: 'A great field for football',
      address: '123 Main St',
      city: 'Cairo',
      pricePerHour: 150.0,
      currency: 'EGP',
      isIndoor: false,
      images: const ['image1.jpg', 'image2.jpg'],
      isActive: true,
      isVerified: true,
      facilities: const ['Parking', 'Lights', 'Changing Rooms'],
      totalBookings: 50,
      averageRating: 4.5,
      totalReviews: 25,
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful retrieval', () {
      test('should return field when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getFieldById(any()),
        ).thenAnswer((_) async => Right(tField));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(Right(tField)));
        verify(() => mockRepository.getFieldById(tFieldId)).called(1);
      });

      test('should return field with all properties', () async {
        // Arrange
        when(
          () => mockRepository.getFieldById(any()),
        ).thenAnswer((_) async => Right(tField));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        result.fold((_) => fail('Should return Right'), (field) {
          expect(field.id, tFieldId);
          expect(field.name, 'Premium Stadium');
          expect(field.pricePerHour, 150.0);
          expect(field.averageRating, 4.5);
          expect(field.facilities.length, 3);
        });
      });

      test('should handle UUID format field IDs', () async {
        // Arrange
        const uuidFieldId = '550e8400-e29b-41d4-a716-446655440000';
        when(
          () => mockRepository.getFieldById(any()),
        ).thenAnswer((_) async => Right(tField));

        // Act
        final result = await useCase(uuidFieldId);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.getFieldById(uuidFieldId)).called(1);
      });
    });

    group('validation failures', () {
      test('should return ValidationFailure when field ID is empty', () async {
        // Act
        final result = await useCase('');

        // Assert
        expect(
          result,
          equals(const Left(ValidationFailure('Field ID cannot be empty'))),
        );
        verifyNever(() => mockRepository.getFieldById(any()));
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch field');
        when(
          () => mockRepository.getFieldById(any()),
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
          () => mockRepository.getFieldById(any()),
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
          () => mockRepository.getFieldById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tFieldId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
