import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/repositories/super_admin_repository.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/update_field_usecase.dart';

class MockSuperAdminRepository extends Mock implements SuperAdminRepository {}

void main() {
  late UpdateFieldUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
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
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(
          fieldId: tFieldId,
          name: 'Updated Stadium',
        );

        // Assert
        expect(result, equals(Right(tUpdatedField)));
      });

      test('should update field name', () async {
        // Arrange
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, name: 'New Name');

        // Assert
        expect(result.isRight(), true);
      });

      test('should update price', () async {
        // Arrange
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedField));

        // Act
        final result = await useCase(fieldId: tFieldId, pricePerHour: 200.0);

        // Assert
        expect(result.isRight(), true);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to update field');
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ValidationFailure when field not found', () async {
        // Arrange
        const tFailure = ValidationFailure('Field not found');
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: 'invalid', name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to update this field');
        when(
          () => mockRepository.updateField(
            fieldId: any(named: 'fieldId'),
            name: any(named: 'name'),
            address: any(named: 'address'),
            description: any(named: 'description'),
            pricePerHour: any(named: 'pricePerHour'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            ownerId: any(named: 'ownerId'),
            sportCategoryId: any(named: 'sportCategoryId'),
            surfaceType: any(named: 'surfaceType'),
            isIndoor: any(named: 'isIndoor'),
            isVerified: any(named: 'isVerified'),
            isActive: any(named: 'isActive'),
            facilities: any(named: 'facilities'),
            paymentPhone: any(named: 'paymentPhone'),
            paymentMethod: any(named: 'paymentMethod'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(fieldId: tFieldId, name: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
