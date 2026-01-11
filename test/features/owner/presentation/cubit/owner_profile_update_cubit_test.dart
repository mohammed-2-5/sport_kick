import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_update_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_update_state.dart';

// Mock Use Case
class MockUpdateOwnerProfileUseCase extends Mock
    implements UpdateOwnerProfileUseCase {}

void main() {
  late OwnerProfileUpdateCubit cubit;
  late MockUpdateOwnerProfileUseCase mockUpdateOwnerProfile;

  // Test data
  const ownerId = 'owner-1';
  const fullName = 'John Owner';
  const phone = '0123456789';

  setUp(() {
    mockUpdateOwnerProfile = MockUpdateOwnerProfileUseCase();
    cubit = OwnerProfileUpdateCubit(
      updateOwnerProfileUseCase: mockUpdateOwnerProfile,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('OwnerProfileUpdateCubit', () {
    test('initial state is OwnerProfileUpdateInitial', () {
      expect(cubit.state, const OwnerProfileUpdateInitial());
    });
  });

  group('updateProfile', () {
    blocTest<OwnerProfileUpdateCubit, OwnerProfileUpdateState>(
      'emits [Loading, ProfileUpdated] when update succeeds',
      build: () {
        when(
          () => mockUpdateOwnerProfile(
            ownerId: ownerId,
            fullName: fullName,
            phone: phone,
          ),
        ).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      act: (cubit) => cubit.updateProfile(
        ownerId: ownerId,
        fullName: fullName,
        phone: phone,
      ),
      expect: () => [
        const OwnerProfileUpdateLoading(message: 'Updating profile...'),
        const ProfileUpdated('Profile updated successfully'),
      ],
    );

    blocTest<OwnerProfileUpdateCubit, OwnerProfileUpdateState>(
      'emits [Loading, Error] when update fails',
      build: () {
        when(
          () => mockUpdateOwnerProfile(
            ownerId: ownerId,
            fullName: fullName,
            phone: phone,
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return cubit;
      },
      act: (cubit) => cubit.updateProfile(
        ownerId: ownerId,
        fullName: fullName,
        phone: phone,
      ),
      expect: () => [
        const OwnerProfileUpdateLoading(message: 'Updating profile...'),
        const OwnerProfileUpdateError('Update failed'),
      ],
    );
  });

  group('reset', () {
    blocTest<OwnerProfileUpdateCubit, OwnerProfileUpdateState>(
      'resets to initial state',
      build: () => cubit,
      seed: () => const OwnerProfileUpdateError('Error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const OwnerProfileUpdateInitial()],
    );
  });
}
