import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_field_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late UpdateFieldUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = UpdateFieldUseCase(mockRepository);
  });

  group('UpdateFieldUseCase', () {
    const tFieldId = 'field-123';
    final tNow = DateTime(2026, 1, 7);
    final tUpdatedField = FieldEntity(
      id: tFieldId,
      ownerId: 'owner-123',
      sportCategoryId: 'football',
      name: 'Updated Stadium',
      address: '123 Main St',
      city: 'Cairo',
      pricePerHour: 150.0,
      currency: 'EGP',
      isIndoor: false,
      images: const [],
      isActive: true,
      isVerified: true,
      facilities: const [],
      totalBookings: 50,
      createdAt: tNow,
      updatedAt: tNow,
    );

    group('successful update', () {
      test('should return updated field when update succeeds', () async {
        // Arrange
        final updates = {'name': 'Updated Stadium', 'pricePerHour': 150.0};

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result, equals(Right(tUpdatedField)));
      });

      test('should update field name', () async {
        // Arrange
        final updates = {'name': 'New Name'};

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.updateField(tFieldId, updates)).called(1);
      });

      test('should update field price', () async {
        // Arrange
        final updates = {'pricePerHour': 200.0};

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result.isRight(), true);
      });

      test('should update multiple fields at once', () async {
        // Arrange
        final updates = {
          'name': 'Updated Name',
          'pricePerHour': 150.0,
          'description': 'Updated description',
          'isActive': true,
        };

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result.isRight(), true);
        verify(() => mockRepository.updateField(tFieldId, updates)).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        final updates = {'name': 'Test'};

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        verify(() => mockRepository.updateField(tFieldId, updates)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        final updates = {'name': 'Test'};
        const tFailure = ServerFailure('Failed to update field');

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        final updates = {'name': 'Test'};
        const tFailure = ValidationFailure('Field not found');

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          fieldId: 'invalid-field',
          updates: updates,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        final updates = {'name': 'Test'};
        const tFailure = AuthFailure('Not authorized to update this field');

        when(
          () => mockRepository.updateField(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, updates: updates);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
