import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_all_fields_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late GetAllFieldsUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = GetAllFieldsUseCase(mockRepository);
  });

  group('GetAllFieldsUseCase', () {
    final tNow = DateTime(2026, 1, 1);
    final tFields = <FieldEntity>[
      FieldEntity(
        id: 'field-1',
        ownerId: 'owner-1',
        sportCategoryId: 'football',
        name: 'Stadium A',
        address: '123 Main St',
        city: 'Cairo',
        pricePerHour: 100.0,
        currency: 'EGP',
        isIndoor: false,
        images: const ['image1.jpg'],
        isActive: true,
        isVerified: true,
        facilities: const ['Parking', 'Lights'],
        totalBookings: 10,
        createdAt: tNow,
        updatedAt: tNow,
      ),
      FieldEntity(
        id: 'field-2',
        ownerId: 'owner-2',
        sportCategoryId: 'basketball',
        name: 'Court B',
        address: '456 Side St',
        city: 'Alexandria',
        pricePerHour: 80.0,
        currency: 'EGP',
        isIndoor: true,
        images: const ['image2.jpg'],
        isActive: true,
        isVerified: true,
        facilities: const ['AC'],
        totalBookings: 5,
        createdAt: tNow,
        updatedAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return list of fields when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tFields)));
        verify(() => mockRepository.getAllFields(cityId: null)).called(1);
      });

      test(
        'should return fields filtered by city when cityId provided',
        () async {
          // Arrange
          const cityId = 'city-123';
          when(
            () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
          ).thenAnswer((_) async => Right([tFields[0]]));

          // Act
          final result = await useCase(cityId: cityId);

          // Assert
          expect(result.isRight(), true);
          verify(() => mockRepository.getAllFields(cityId: cityId)).called(1);
        },
      );

      test('should return empty list when no fields exist', () async {
        // Arrange
        when(
          () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase();

        // Assert
        result.fold(
          (_) => fail('Should return Right'),
          (fields) => expect(fields, isEmpty),
        );
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFields));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getAllFields(cityId: null)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch fields');
        when(
          () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure on network error', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getAllFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
