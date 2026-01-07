import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';

import '../../../../helpers/mock_dependencies.dart';

void main() {
  late GetCurrentUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    final tUserEntity = UserEntity(
      id: 'user-123',
      email: 'test@example.com',
      fullName: 'Test User',
      phone: '+201234567890',
      role: 'user',
      isActive: true,
      avatarUrl: 'https://example.com/avatar.jpg',
      preferredSports: ['sport-1', 'sport-2'],
      passwordChanged: true,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 15),
      selectedCityId: 'city-1',
      fieldsCount: 0,
      totalRevenue: 0.0,
    );

    group('successful retrieval', () {
      test('should return UserEntity when user is logged in', () async {
        // Arrange
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user, equals(tUserEntity)),
        );
        verify(() => mockRepository.getCurrentUser()).called(1);
      });

      test('should return null when no user is logged in', () async {
        // Arrange
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user, isNull),
        );
      });

      test('should return admin user when admin is logged in', () async {
        // Arrange
        final adminUser = tUserEntity.copyWith(
          role: 'admin',
          fieldsCount: 5,
          totalRevenue: 10000.0,
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(adminUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user, equals(adminUser));
          expect(user?.role, 'admin');
          expect(user?.isAdmin, true);
        });
      });

      test(
        'should return super admin user when super admin is logged in',
        () async {
          // Arrange
          final superAdminUser = tUserEntity.copyWith(role: 'super_admin');
          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => Right(superAdminUser));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isRight(), true);
          result.fold((_) => fail('Should return Right'), (user) {
            expect(user, equals(superAdminUser));
            expect(user?.role, 'super_admin');
            expect(user?.isSuperAdmin, true);
          });
        },
      );

      test('should return user without optional fields', () async {
        // Arrange
        final minimalUser = UserEntity(
          id: 'user-456',
          email: 'minimal@example.com',
          role: 'user',
          isActive: true,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(minimalUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user, equals(minimalUser));
          expect(user?.fullName, isNull);
          expect(user?.phone, isNull);
          expect(user?.avatarUrl, isNull);
          expect(user?.selectedCityId, isNull);
        });
      });

      test('should return inactive user', () async {
        // Arrange
        final inactiveUser = tUserEntity.copyWith(isActive: false);
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(inactiveUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user, equals(inactiveUser));
          expect(user?.isActive, false);
        });
      });

      test('should return user with empty preferred sports list', () async {
        // Arrange
        final userWithNoSports = tUserEntity.copyWith(preferredSports: []);
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(userWithNoSports));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user?.preferredSports, isEmpty);
        });
      });

      test('should return user who has not changed password', () async {
        // Arrange
        final userNoPasswordChange = tUserEntity.copyWith(
          passwordChanged: false,
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(userNoPasswordChange));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user?.passwordChanged, false);
        });
      });
    });

    group('repository failures', () {
      test('should return ServerFailure when repository call fails', () async {
        // Arrange
        const tFailure = ServerFailure('Failed to get current user');
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return NetworkFailure when network error occurs', () async {
        // Arrange
        const tFailure = NetworkFailure('No internet connection');
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return CacheFailure when local session data is corrupted',
        () async {
          // Arrange
          const tFailure = CacheFailure('Session data corrupted');
          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );

      test('should return AuthFailure when session is invalid', () async {
        // Arrange
        const tFailure = AuthFailure('Invalid session');
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test('should return ServerFailure when session has expired', () async {
        // Arrange
        const tFailure = ServerFailure('Session expired');
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, equals(const Left(tFailure)));
      });

      test(
        'should return ServerFailure when user data is incomplete',
        () async {
          // Arrange
          const tFailure = ServerFailure('User data incomplete');
          when(
            () => mockRepository.getCurrentUser(),
          ).thenAnswer((_) async => const Left(tFailure));

          // Act
          final result = await useCase();

          // Assert
          expect(result, equals(const Left(tFailure)));
        },
      );
    });

    group('edge cases', () {
      test('should call repository only once', () async {
        // Arrange
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        await useCase();

        // Assert
        verify(() => mockRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should handle multiple consecutive calls', () async {
        // Arrange
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(tUserEntity));

        // Act
        final result1 = await useCase();
        final result2 = await useCase();
        final result3 = await useCase();

        // Assert
        expect(result1.isRight(), true);
        expect(result2.isRight(), true);
        expect(result3.isRight(), true);
        verify(() => mockRepository.getCurrentUser()).called(3);
      });

      test('should handle user with very long email', () async {
        // Arrange
        final longEmailUser = tUserEntity.copyWith(
          email: 'very.long.email.address.for.testing@example.com',
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(longEmailUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(
            user?.email,
            'very.long.email.address.for.testing@example.com',
          ),
        );
      });

      test('should handle user with unicode characters in name', () async {
        // Arrange
        final unicodeUser = tUserEntity.copyWith(fullName: 'محمد أحمد 你好');
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(unicodeUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user?.fullName, 'محمد أحمد 你好'),
        );
      });

      test('should handle user with special characters in name', () async {
        // Arrange
        final specialCharUser = tUserEntity.copyWith(
          fullName: "O'Brien-Smith (Jr.)",
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(specialCharUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user?.fullName, "O'Brien-Smith (Jr.)"),
        );
      });

      test('should handle user with many preferred sports', () async {
        // Arrange
        final manyPreferredSports = List.generate(20, (i) => 'sport-$i');
        final userWithManySports = tUserEntity.copyWith(
          preferredSports: manyPreferredSports,
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(userWithManySports));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return Right'), (user) {
          expect(user?.preferredSports.length, 20);
          expect(user?.preferredSports, manyPreferredSports);
        });
      });

      test('should handle user with very high field count', () async {
        // Arrange
        final highFieldCountUser = tUserEntity.copyWith(
          role: 'admin',
          fieldsCount: 1000,
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(highFieldCountUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user?.fieldsCount, 1000),
        );
      });

      test('should handle user with very high revenue', () async {
        // Arrange
        final highRevenueUser = tUserEntity.copyWith(
          role: 'admin',
          totalRevenue: 999999999.99,
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(highRevenueUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user?.totalRevenue, 999999999.99),
        );
      });

      test('should handle user with international phone number', () async {
        // Arrange
        final internationalPhoneUser = tUserEntity.copyWith(
          phone: '+44 20 7946 0958',
        );
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(internationalPhoneUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (user) => expect(user?.phone, '+44 20 7946 0958'),
        );
      });
    });
  });
}
