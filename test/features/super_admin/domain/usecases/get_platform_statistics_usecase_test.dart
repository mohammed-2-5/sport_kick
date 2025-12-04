import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_platform_statistics_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetPlatformStatisticsUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = GetPlatformStatisticsUseCase(mockRepository);
  });

  group('GetPlatformStatisticsUseCase', () {
    const tStatistics = PlatformStatisticsEntity(
      totalUsers: 100,
      newUsersThisMonth: 10,
      totalAdmins: 5,
      activeFields: 20,
      totalFields: 25,
      citiesWithFields: 3,
      activeCities: 2,
      totalBookings: 500,
      pendingBookings: 50,
      confirmedBookings: 400,
      completedBookings: 350,
      canceledBookings: 50,
      manualBookings: 20,
      bookingsThisMonth: 100,
      totalRevenue: 10000.0,
      revenueThisMonth: 2000.0,
    );

    test(
      'should return PlatformStatisticsEntity when repository call succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.getPlatformStatistics(),
        ).thenAnswer((_) async => const Right(tStatistics));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Right(tStatistics)));
        verify(() => mockRepository.getPlatformStatistics()).called(1);
      },
    );

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to get statistics');
      when(
        () => mockRepository.getPlatformStatistics(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left(tFailure)));
      verify(() => mockRepository.getPlatformStatistics()).called(1);
    });

    test(
      'should call repository.getPlatformStatistics() exactly once',
      () async {
        // Arrange
        when(
          () => mockRepository.getPlatformStatistics(),
        ).thenAnswer((_) async => const Right(tStatistics));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getPlatformStatistics()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should not transform data (pass-through from repository)', () async {
      // Arrange
      when(
        () => mockRepository.getPlatformStatistics(),
      ).thenAnswer((_) async => const Right(tStatistics));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      final statistics = result.getOrElse(
        () => const PlatformStatisticsEntity(
          totalUsers: 0,
          newUsersThisMonth: 0,
          totalAdmins: 0,
          activeFields: 0,
          totalFields: 0,
          citiesWithFields: 0,
          activeCities: 0,
          totalBookings: 0,
          pendingBookings: 0,
          confirmedBookings: 0,
          completedBookings: 0,
          canceledBookings: 0,
          manualBookings: 0,
          bookingsThisMonth: 0,
          totalRevenue: 0,
          revenueThisMonth: 0,
        ),
      );
      expect(statistics, equals(tStatistics));
      expect(statistics.totalUsers, equals(100));
      expect(statistics.totalRevenue, equals(10000.0));
    });
  });
}
