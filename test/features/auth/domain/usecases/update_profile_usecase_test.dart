import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/update_profile_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late UpdateProfileUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  group('UpdateProfileUseCase', () {
    final tUpdatedUserEntity = UserEntity(
      id: 'user-123',
      email: 'user@example.com',
      fullName: 'Updated Name',
      phone: '+201234567890',
      role: 'user',
      isActive: true,
      passwordChanged: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 15),
    );

    group('successful profile update', () {
      test(
        'should return updated UserEntity when both fullName and phone are provided',
        () async {
          // Arrange
          final params = UpdateProfileParams(
            fullName: 'Updated Name',
            phone: '+201234567890',
          );

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => Right(tUpdatedUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Should return Right'),
            (user) => expect(user, equals(tUpdatedUserEntity)),
          );
          verify(
            () => mockRepository.updateProfile(
              fullName: 'Updated Name',
              phone: '+201234567890',
              avatarUrl: null,
              preferredSports: null,
            ),
          ).called(1);
        },
      );

      test('should succeed with only fullName', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateProfile(
            fullName: 'Updated Name',
            phone: null,
            avatarUrl: null,
            preferredSports: null,
          ),
        ).called(1);
      });

      test('should succeed with only phone', () async {
        // Arrange
        final params = UpdateProfileParams(phone: '+201234567890');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateProfile(
            fullName: null,
            phone: '+201234567890',
            avatarUrl: null,
            preferredSports: null,
          ),
        ).called(1);
      });

      test('should succeed with both fields as null', () async {
        // Arrange
        final params = UpdateProfileParams();

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockRepository.updateProfile(
            fullName: null,
            phone: null,
            avatarUrl: null,
            preferredSports: null,
          ),
        ).called(1);
      });

      test(
        'should succeed with full name containing special characters',
        () async {
          // Arrange
          final params = UpdateProfileParams(fullName: "O'Brien-Smith Jr.");

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => Right(tUpdatedUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should succeed with Arabic full name', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'محمد أحمد');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should succeed with international phone number', () async {
        // Arrange
        final params = UpdateProfileParams(phone: '+44 20 7946 0958');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed with phone number containing spaces and dashes',
        () async {
          // Arrange
          final params = UpdateProfileParams(phone: '+20 123 456-7890');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => Right(tUpdatedUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should succeed with very long full name', () async {
        // Arrange
        final longName = 'A' * 200;
        final params = UpdateProfileParams(fullName: longName);

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test(
        'should succeed with full name containing multiple spaces',
        () async {
          // Arrange
          final params = UpdateProfileParams(
            fullName: 'First    Middle    Last',
          );

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => Right(tUpdatedUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );
    });

    group('validation failures', () {
      test(
        'should return ValidationFailure when full name is empty string',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Full name cannot be empty');
          final params = UpdateProfileParams(fullName: '');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when phone format is invalid',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Invalid phone number format');
          final params = UpdateProfileParams(phone: 'invalid-phone');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when phone is empty string',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Phone number cannot be empty');
          final params = UpdateProfileParams(phone: '');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when full name is only whitespace',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Full name cannot be empty');
          final params = UpdateProfileParams(fullName: '   ');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test(
        'should return ValidationFailure when phone already exists',
        () async {
          // Arrange
          const tFailure = ValidationFailure('Phone number already in use');
          final params = UpdateProfileParams(phone: '+201234567890');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('authentication failures', () {
      test(
        'should return AuthFailure when user is not authenticated',
        () async {
          // Arrange
          const tFailure = AuthFailure('User not authenticated');
          final params = UpdateProfileParams(fullName: 'Updated Name');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return AuthFailure when session has expired', () async {
        // Arrange
        const tFailure = AuthFailure('Session expired');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return AuthFailure when account is inactive', () async {
        // Arrange
        const tFailure = AuthFailure('Account is inactive');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('network and server failures', () {
      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when server error occurs', () async {
        // Arrange
        const tFailure = ServerFailure('Server error');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when database update fails', () async {
        // Arrange
        const tFailure = ServerFailure('Database error');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure on timeout', () async {
        // Arrange
        const tFailure = ServerFailure('Request timeout');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        final params = UpdateProfileParams(
          fullName: 'Updated Name',
          phone: '+201234567890',
        );

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        await useCase(params);

        // Assert
        verify(
          () => mockRepository.updateProfile(
            fullName: 'Updated Name',
            phone: '+201234567890',
            avatarUrl: null,
            preferredSports: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test(
        'should handle full name with leading and trailing spaces',
        () async {
          // Arrange
          final params = UpdateProfileParams(fullName: '  Updated Name  ');

          when(
            () => mockRepository.updateProfile(
              fullName: any(named: 'fullName'),
              phone: any(named: 'phone'),
              avatarUrl: any(named: 'avatarUrl'),
              preferredSports: any(named: 'preferredSports'),
            ),
          ).thenAnswer((_) async => Right(tUpdatedUserEntity));

          // Act
          final result = await useCase(params);

          // Assert
          expect(result.isRight(), true);
        },
      );

      test('should handle phone with leading and trailing spaces', () async {
        // Arrange
        final params = UpdateProfileParams(phone: '  +201234567890  ');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle full name with unicode characters', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'John 你好 محمد');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle full name with emojis', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'John Doe 😀⚽');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle single character full name', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'X');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle phone without country code', () async {
        // Arrange
        final params = UpdateProfileParams(phone: '01234567890');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
      });

      test('should handle multiple consecutive updates', () async {
        // Arrange
        final params1 = UpdateProfileParams(fullName: 'Name 1');
        final params2 = UpdateProfileParams(fullName: 'Name 2');
        final params3 = UpdateProfileParams(phone: '+201111111111');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result1 = await useCase(params1);
        final result2 = await useCase(params2);
        final result3 = await useCase(params3);

        // Assert
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        expect(result3.isRight(), true);
        verify(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).called(3);
      });

      test('should handle concurrent update requests', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final results = await Future.wait([
          useCase(params),
          useCase(params),
          useCase(params),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isRight(), true);
        }
      });

      test('should not throw exception on update', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act & Assert
        expect(() => useCase(params), returnsNormally);
      });
    });

    group('repository interaction', () {
      test('should pass null values correctly to repository', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        await useCase(params);

        // Assert
        verify(
          () => mockRepository.updateProfile(
            fullName: 'Updated Name',
            phone: null,
            avatarUrl: null,
            preferredSports: null,
          ),
        ).called(1);
      });

      test('should propagate repository result unchanged', () async {
        // Arrange
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => Right(tUpdatedUserEntity));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user, equals(tUpdatedUserEntity)),
        );
      });

      test('should propagate repository failure unchanged', () async {
        // Arrange
        const tFailure = ServerFailure('Test failure');
        final params = UpdateProfileParams(fullName: 'Updated Name');

        when(
          () => mockRepository.updateProfile(
            fullName: any(named: 'fullName'),
            phone: any(named: 'phone'),
            avatarUrl: any(named: 'avatarUrl'),
            preferredSports: any(named: 'preferredSports'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(params);

        // Assert
        expect(result, equals(const Left(tFailure)));
      });
    });
  });
}
