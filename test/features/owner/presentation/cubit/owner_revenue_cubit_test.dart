import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/entities/owner_revenue_entity.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_revenue/owner_revenue_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_revenue/owner_revenue_state.dart';

// Mock Use Case
class MockGetOwnerRevenueUseCase extends Mock
    implements GetOwnerRevenueUseCase {}

void main() {
  late OwnerRevenueCubit cubit;
  late MockGetOwnerRevenueUseCase mockGetOwnerRevenue;

  // Test data
  const ownerId = 'owner-1';
  const testRevenue = OwnerRevenueEntity(
    totalRevenue: 1000.0,
    monthlyRevenue: 200.0,
    totalBookings: 10,
    monthlyBookings: 2,
    pendingBookings: 1,
    revenueByField: {'field-1': 500.0, 'field-2': 500.0},
  );

  setUp(() {
    mockGetOwnerRevenue = MockGetOwnerRevenueUseCase();
    cubit = OwnerRevenueCubit(getOwnerRevenueUseCase: mockGetOwnerRevenue);
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerRevenueCubit', () {
    test('initial state is OwnerRevenueInitial', () {
      expect(cubit.state, const OwnerRevenueInitial());
    });
  });

  group('loadOwnerRevenue', () {
    const loadingMessage = 'Loading revenue data...';

    blocTest<OwnerRevenueCubit, OwnerRevenueState>(
      'emits [Loading, Loaded] when load succeeds',
      build: () {
        when(
          () => mockGetOwnerRevenue(ownerId: ownerId),
        ).thenAnswer((_) async => const Right(testRevenue));
        return cubit;
      },
      act: (cubit) => cubit.loadOwnerRevenue(ownerId),
      expect: () => [
        const OwnerRevenueLoading(message: loadingMessage),
        const OwnerRevenueLoaded(testRevenue),
      ],
    );

    blocTest<OwnerRevenueCubit, OwnerRevenueState>(
      'emits [Loading, Error] when load fails',
      build: () {
        when(
          () => mockGetOwnerRevenue(ownerId: ownerId),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return cubit;
      },
      act: (cubit) => cubit.loadOwnerRevenue(ownerId),
      expect: () => [
        const OwnerRevenueLoading(message: loadingMessage),
        const OwnerRevenueError('Network error'),
      ],
    );
  });

  group('reset', () {
    blocTest<OwnerRevenueCubit, OwnerRevenueState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const OwnerRevenueError('Error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const OwnerRevenueInitial()],
    );
  });
}
