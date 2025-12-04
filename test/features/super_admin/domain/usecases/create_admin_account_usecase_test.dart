import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late CreateAdminAccountUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = CreateAdminAccountUseCase(mockRepository);
  });

  group('CreateAdminAccountUseCase', () {
    const tEmail = 'admin@test.com';
    const tFullName = 'Test Admin';
    const tPassword = 'TestPass123!';

    final tAdminInvitation = AdminInvitationEntity(
      id: 'admin-id',
      email: tEmail,
      defaultPassword: tPassword,
      fullName: tFullName,
      createdBy: 'super-admin-id',
      status: AdminInvitationStatus.pending,
      createdAt: DateTime.now(),
    );

    test(
      'should return AdminInvitationEntity when creation succeeds',
      () async {
        // Arrange
        when(
          () => mockRepository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            defaultPassword: tPassword,
          ),
        ).thenAnswer((_) async => Right(tAdminInvitation));

        // Act
        final result = await useCase(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        );

        // Assert
        expect(result, equals(Right(tAdminInvitation)));
        verify(
          () => mockRepository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            defaultPassword: tPassword,
          ),
        ).called(1);
      },
    );

    test('should use provided defaultPassword if given', () async {
      // Arrange
      when(
        () => mockRepository.createAdminAccount(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        ),
      ).thenAnswer((_) async => Right(tAdminInvitation));

      // Act
      await useCase(
        email: tEmail,
        fullName: tFullName,
        defaultPassword: tPassword,
      );

      // Assert
      verify(
        () => mockRepository.createAdminAccount(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        ),
      ).called(1);
    });

    test('should return ConflictFailure when email already exists', () async {
      // Arrange
      const tFailure = ConflictFailure('Email already exists');
      when(
        () => mockRepository.createAdminAccount(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(
        email: tEmail,
        fullName: tFullName,
        defaultPassword: tPassword,
      );

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to create admin');
      when(
        () => mockRepository.createAdminAccount(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(
        email: tEmail,
        fullName: tFullName,
        defaultPassword: tPassword,
      );

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test(
      'should call repository.createAdminAccount() with correct parameters',
      () async {
        // Arrange
        when(
          () => mockRepository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            defaultPassword: tPassword,
          ),
        ).thenAnswer((_) async => Right(tAdminInvitation));

        // Act
        await useCase(
          email: tEmail,
          fullName: tFullName,
          defaultPassword: tPassword,
        );

        // Assert
        verify(
          () => mockRepository.createAdminAccount(
            email: tEmail,
            fullName: tFullName,
            defaultPassword: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
