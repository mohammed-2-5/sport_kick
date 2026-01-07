import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late GetOwnerRevenueUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = GetOwnerRevenueUseCase(mockRepository);
  });

  group('GetOwnerRevenueUseCase', () {
    const tOwnerId = 'owner-123';
    const tRevenue = OwnerRevenueEntity(
      totalRevenue: 50000.0,
      monthlyRevenue: 10000.0,
      totalBookings: 200,
      monthlyBookings: 40,
      pendingBookings: 5,
      revenueByField: {'field-1': 30000.0, 'field-2': 20000.0},
    );

    group('successful retrieval', () {
      test('should return revenue data when call succeeds', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Right(tRevenue));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Right(tRevenue)));
        verify(() => mockRepository.getOwnerRevenue(tOwnerId)).called(1);
      });

      test('should return revenue with all statistics', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Right(tRevenue));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold((_) => fail('Should return Right'), (revenue) {
          expect(revenue.totalRevenue, 50000.0);
          expect(revenue.monthlyRevenue, 10000.0);
          expect(revenue.totalBookings, 200);
          expect(revenue.monthlyBookings, 40);
          expect(revenue.pendingBookings, 5);
        });
      });

      test('should return revenue breakdown by field', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Right(tRevenue));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold((_) => fail('Should return Right'), (revenue) {
          expect(revenue.revenueByField.length, 2);
          expect(revenue.revenueByField['field-1'], 30000.0);
          expect(revenue.revenueByField['field-2'], 20000.0);
        });
      });

      test('should return zero revenue for new owner', () async {
        // Arrange
        const emptyRevenue = OwnerRevenueEntity(
          totalRevenue: 0,
          monthlyRevenue: 0,
          totalBookings: 0,
          monthlyBookings: 0,
          pendingBookings: 0,
          revenueByField: {},
        );

        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Right(emptyRevenue));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        result.fold((_) => fail('Should return Right'), (revenue) {
          expect(revenue.totalRevenue, 0);
          expect(revenue.totalBookings, 0);
        });
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Right(tRevenue));

        // Act
        await useCase(ownerId: tOwnerId);

        // Assert
        verify(() => mockRepository.getOwnerRevenue(tOwnerId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get revenue data');
        when(
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to view revenue');
        when(
          () => mockRepository.getOwnerRevenue(any()),
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
          () => mockRepository.getOwnerRevenue(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
