import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/assign_field_to_admin_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late AssignFieldToAdminUseCase useCase;
  late MockSuperAdminRepository mockRepository;

  setUp(() {
    mockRepository = MockSuperAdminRepository();
    useCase = AssignFieldToAdminUseCase(mockRepository);
  });

  group('AssignFieldToAdminUseCase', () {
    const tAdminId = 'admin-123';
    const tFieldId = 'field-123';

    test('should return void when assignment succeeds', () async {
      // Arrange
      when(
        () => mockRepository.assignFieldToAdmin(
          adminId: tAdminId,
          fieldId: tFieldId,
        ),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(adminId: tAdminId, fieldId: tFieldId);

      // Assert
      expect(result, equals(const Right(null)));
      verify(
        () => mockRepository.assignFieldToAdmin(
          adminId: tAdminId,
          fieldId: tFieldId,
        ),
      ).called(1);
    });

    test('should return NotFoundFailure when admin not found', () async {
      // Arrange
      const tFailure = NotFoundFailure('Admin not found');
      when(
        () => mockRepository.assignFieldToAdmin(
          adminId: tAdminId,
          fieldId: tFieldId,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(adminId: tAdminId, fieldId: tFieldId);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return NotFoundFailure when field not found', () async {
      // Arrange
      const tFailure = NotFoundFailure('Field not found');
      when(
        () => mockRepository.assignFieldToAdmin(
          adminId: tAdminId,
          fieldId: tFieldId,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(adminId: tAdminId, fieldId: tFieldId);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to assign field');
      when(
        () => mockRepository.assignFieldToAdmin(
          adminId: tAdminId,
          fieldId: tFieldId,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(adminId: tAdminId, fieldId: tFieldId);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test(
      'should call repository.assignFieldToAdmin() with correct parameters',
      () async {
        // Arrange
        when(
          () => mockRepository.assignFieldToAdmin(
            adminId: tAdminId,
            fieldId: tFieldId,
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        await useCase(adminId: tAdminId, fieldId: tFieldId);

        // Assert
        verify(
          () => mockRepository.assignFieldToAdmin(
            adminId: tAdminId,
            fieldId: tFieldId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
