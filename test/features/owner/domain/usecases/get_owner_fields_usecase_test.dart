import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_fields_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late GetOwnerFieldsUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = GetOwnerFieldsUseCase(mockRepository);
  });

  group('GetOwnerFieldsUseCase', () {
    const tOwnerId = 'owner-123';
    final tNow = DateTime(2026, 1, 7);
    final tFields = <FieldEntity>[
      FieldEntity(
        id: 'field-1',
        ownerId: tOwnerId,
        sportCategoryId: 'football',
        name: 'Stadium A',
        address: '123 Main St',
        city: 'Cairo',
        pricePerHour: 100.0,
        currency: 'EGP',
        isIndoor: false,
        images: const [],
        isActive: true,
        isVerified: true,
        facilities: const [],
        totalBookings: 50,
        createdAt: tNow,
        updatedAt: tNow,
      ),
      FieldEntity(
        id: 'field-2',
        ownerId: tOwnerId,
        sportCategoryId: 'basketball',
        name: 'Court B',
        address: '456 Side St',
        city: 'Cairo',
        pricePerHour: 80.0,
        currency: 'EGP',
        isIndoor: true,
        images: const [],
        isActive: true,
        isVerified: true,
        facilities: const [],
        totalBookings: 30,
        createdAt: tNow,
        updatedAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return list of fields when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(Right(tFields)));
        verify(() => mockRepository.getOwnerFields(tOwnerId)).called(1);
      });

      test('should return empty list when owner has no fields', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (fields) => expect(fields, isEmpty),
        );
      });

      test('should return fields with correct owner ID', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold((_) => fail('Should return Right'), (fields) {
          for (final field in fields) {
            expect(field.ownerId, tOwnerId);
          }
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        await useCase(ownerId: tOwnerId);

        // Assert
        verify(() => mockRepository.getOwnerFields(tOwnerId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get owner fields');
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to view these fields');
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getOwnerFields(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
