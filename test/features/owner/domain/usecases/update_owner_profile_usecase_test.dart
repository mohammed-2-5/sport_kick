import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/owner/domain/repositories/owner_repository.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late UpdateOwnerProfileUseCase useCase;
  late MockOwnerRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerRepository();
    useCase = UpdateOwnerProfileUseCase(mockRepository);
  });

  group('UpdateOwnerProfileUseCase', () {
    const tOwnerId = 'owner-123';

    group('successful update', () {
      test('should return Right(void) when update succeeds', () async {
        // Arrange
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          ownerId: tOwnerId,
          fullName: 'John Doe',
          phone: '+201234567890',
        );

        // Assert
        expect(result.isRight(), true);
      });

      test('should update only name', () async {
        // Arrange
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(ownerId: tOwnerId, fullName: 'New Name');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateOwnerProfile(
            ownerId: tOwnerId,
            fullName: 'New Name',
            phone: null,
          ),
        ).called(1);
      });

      test('should update only phone', () async {
        // Arrange
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(ownerId: tOwnerId, phone: '+201234567890');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateOwnerProfile(
            ownerId: tOwnerId,
            fullName: null,
            phone: '+201234567890',
          ),
        ).called(1);
      });

      test('should call repository exactly once', () async {
        // Arrange
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(ownerId: tOwnerId, fullName: 'Test');

        // Assert
        verify(
          () => mockRepository.updateOwnerProfile(
            ownerId: tOwnerId,
            fullName: 'Test',
            phone: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });
    });

    group('failures', () {
      test('should return ServerFailure when repository fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to update profile');
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId, fullName: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when not authorized', () async {
        // Arrange
        const tFailure = AuthFailure('Not authorized to update this profile');
        when(
          () => mockRepository.updateOwnerProfile(
            ownerId: any(named: 'ownerId'),
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(ownerId: tOwnerId, fullName: 'Test');

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ValidationFailure for invalid phone number',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid phone number format');
          when(
            () => mockRepository.updateOwnerProfile(
              ownerId: any(named: 'ownerId'),
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(ownerId: tOwnerId, phone: 'invalid');

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });
  });
}
