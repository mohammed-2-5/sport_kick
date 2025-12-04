import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_users_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetAllUsersUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = GetAllUsersUseCase(mockRepository);
  });

  group('GetAllUsersUseCase', () {
    final tUsers = [
      UserEntity(
        id: 'user-1',
        email: 'user1@test.com',
        fullName: 'User One',
        role: 'customer',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      UserEntity(
        id: 'user-2',
        email: 'user2@test.com',
        fullName: 'User Two',
        role: 'owner',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test(
      'should return List<UserEntity> when repository call succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.getAllUsers(),
        ).thenAnswer((_) async => Right(tUsers));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), equals(tUsers));
        verify(() => mockRepository.getAllUsers()).called(1);
      },
    );

    test('should return empty list when no users exist', () async {
      // Arrange
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to get users');
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should call repository.getAllUsers() exactly once', () async {
      // Arrange
      when(
        () => mockRepository.getAllUsers(),
      ).thenAnswer((_) async => Right(tUsers));

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.getAllUsers()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
