import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_admins_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetAllAdminsUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = GetAllAdminsUseCase(mockRepository);
  });

  group('GetAllAdminsUseCase', () {
    final tAdmins = [
      UserEntity(
        id: 'admin-1',
        email: 'admin1@test.com',
        fullName: 'Admin One',
        role: 'admin',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      UserEntity(
        id: 'admin-2',
        email: 'admin2@test.com',
        fullName: 'Admin Two',
        role: 'super_admin',
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
          () => mockRepository.getAllAdmins(),
        ).thenAnswer((_) async => Right(tAdmins));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        expect(result.getOrElse(() => []), equals(tAdmins));
        verify(() => mockRepository.getAllAdmins()).called(1);
      },
    );

    test('should return empty list when no admins exist', () async {
      // Arrange
      when(
        () => mockRepository.getAllAdmins(),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to get admins');
      when(
        () => mockRepository.getAllAdmins(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should call repository.getAllAdmins() exactly once', () async {
      // Arrange
      when(
        () => mockRepository.getAllAdmins(),
      ).thenAnswer((_) async => Right(tAdmins));

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.getAllAdmins()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
