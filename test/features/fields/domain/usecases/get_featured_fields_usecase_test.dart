import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/domain/repositories/field_repository.dart';
import 'package:spo_kick/features/fields/domain/usecases/get_featured_fields_usecase.dart';

class MockFieldRepository extends Mock implements FieldRepository {}

void main() {
  late GetFeaturedFieldsUseCase useCase;
  late MockFieldRepository mockRepository;

  setUp(() {
    mockRepository = MockFieldRepository();
    useCase = GetFeaturedFieldsUseCase(mockRepository);
  });

  group('GetFeaturedFieldsUseCase', () {
    final tNow = DateTime(2026, 1, 1);
    final tFeaturedFields = <FieldEntity>[
      FieldEntity(
        id: 'featured-1',
        sportCategoryId: 'football',
        name: 'Premium Stadium',
        address: 'Downtown',
        city: 'Cairo',
        pricePerHour: 200.0,
        currency: 'EGP',
        isIndoor: false,
        images: const ['image.jpg'],
        isActive: true,
        isVerified: true,
        facilities: const ['VIP Area'],
        totalBookings: 100,
        averageRating: 4.8,
        createdAt: tNow,
        updatedAt: tNow,
      ),
    ];

    group('successful retrieval', () {
      test('should return featured fields when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFeaturedFields));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(Right(tFeaturedFields)));
        verify(() => mockRepository.getFeaturedFields(cityId: null)).called(1);
      });

      test('should return featured fields filtered by city', () async {
        // Arrange
        const cityId = 'city-123';
        when(
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFeaturedFields));

        // Act
        final result = await useCase(cityId: cityId);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.getFeaturedFields(cityId: cityId),
        ).called(1);
      });

      test('should return empty list when no featured fields', () async {
        // Arrange
        when(
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
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
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => Right(tFeaturedFields));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getFeaturedFields(cityId: null)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to fetch featured fields');
        when(
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
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
          () => mockRepository.getFeaturedFields(cityId: any(named: 'cityId')),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
