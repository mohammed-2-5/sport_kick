import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_field_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late CreateFieldUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = CreateFieldUseCase(mockRepository);
  });

  group('CreateFieldUseCase', () {
    const tName = 'Test Field';
    const tSportCategoryId = 'sport-1';
    const tOwnerId = 'owner-123';
    const tCity = 'Cairo';
    const tAddress = '123 Test St';
    const tPrice = 100.0;

    final tField = FieldEntity(
      id: 'field-123',
      name: tName,
      sportCategoryId: tSportCategoryId,
      ownerId: tOwnerId,
      city: tCity,
      address: tAddress,
      pricePerHour: tPrice,
      currency: 'EGP',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should return FieldEntity when creation succeeds', () async {
      // Arrange
      when(
        () => mockRepository.createField(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        ),
      ).thenAnswer((_) async => Right(tField));

      // Act
      final result = await useCase(
        name: tName,
        sportCategoryId: tSportCategoryId,
        ownerId: tOwnerId,
        city: tCity,
        address: tAddress,
        pricePerHour: tPrice,
      );

      // Assert
      expect(result, equals(Right(tField)));
      verify(
        () => mockRepository.createField(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        ),
      ).called(1);
    });

    test('should return NotFoundFailure when city not found', () async {
      // Arrange
      const tFailure = NotFoundFailure('City not found');
      when(
        () => mockRepository.createField(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(
        name: tName,
        sportCategoryId: tSportCategoryId,
        ownerId: tOwnerId,
        city: tCity,
        address: tAddress,
        pricePerHour: tPrice,
      );

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test(
      'should return ConflictFailure when field name already exists',
      () async {
        // Arrange
        const tFailure = ConflictFailure('Field name already exists');
        when(
          () => mockRepository.createField(
            name: tName,
            sportCategoryId: tSportCategoryId,
            ownerId: tOwnerId,
            city: tCity,
            address: tAddress,
            pricePerHour: tPrice,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        );

        // Assert
        expect(result, equals(const Left(tFailure)));
      },
    );

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to create field');
      when(
        () => mockRepository.createField(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(
        name: tName,
        sportCategoryId: tSportCategoryId,
        ownerId: tOwnerId,
        city: tCity,
        address: tAddress,
        pricePerHour: tPrice,
      );

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test(
      'should call repository.createField() with correct parameters',
      () async {
        // Arrange
        when(
          () => mockRepository.createField(
            name: tName,
            sportCategoryId: tSportCategoryId,
            ownerId: tOwnerId,
            city: tCity,
            address: tAddress,
            pricePerHour: tPrice,
          ),
        ).thenAnswer((_) async => Right(tField));

        // Act
        await useCase(
          name: tName,
          sportCategoryId: tSportCategoryId,
          ownerId: tOwnerId,
          city: tCity,
          address: tAddress,
          pricePerHour: tPrice,
        );

        // Assert
        verify(
          () => mockRepository.createField(
            name: tName,
            sportCategoryId: tSportCategoryId,
            ownerId: tOwnerId,
            city: tCity,
            address: tAddress,
            pricePerHour: tPrice,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
