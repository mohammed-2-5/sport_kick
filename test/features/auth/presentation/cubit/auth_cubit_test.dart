import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/login_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/register_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:spo_kick/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';

// Mock Use Cases
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

// Register fallback values for params
class FakeLoginParams extends Fake implements LoginParams {}

class FakeRegisterParams extends Fake implements RegisterParams {}

class FakeChangePasswordParams extends Fake implements ChangePasswordParams {}

class FakeUpdateProfileParams extends Fake implements UpdateProfileParams {}

void main() {
  late AuthCubit authCubit;
  late MockLoginUseCase mockLogin;
  late MockRegisterUseCase mockRegister;
  late MockLogoutUseCase mockLogout;
  late MockGetCurrentUserUseCase mockGetCurrentUser;
  late MockChangePasswordUseCase mockChangePassword;
  late MockResetPasswordUseCase mockResetPassword;
  late MockUpdateProfileUseCase mockUpdateProfile;

  // Test data
  final testUser = UserEntity(
    id: 'user-1',
    email: 'test@example.com',
    fullName: 'Test User',
    role: 'user',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testAdmin = UserEntity(
    id: 'admin-1',
    email: 'admin@example.com',
    fullName: 'Test Admin',
    role: 'admin',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeChangePasswordParams());
    registerFallbackValue(FakeUpdateProfileParams());
  });

  setUp(() {
    mockLogin = MockLoginUseCase();
    mockRegister = MockRegisterUseCase();
    mockLogout = MockLogoutUseCase();
    mockGetCurrentUser = MockGetCurrentUserUseCase();
    mockChangePassword = MockChangePasswordUseCase();
    mockResetPassword = MockResetPasswordUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();

    authCubit = AuthCubit(
      loginUseCase: mockLogin,
      registerUseCase: mockRegister,
      logoutUseCase: mockLogout,
      getCurrentUserUseCase: mockGetCurrentUser,
      changePasswordUseCase: mockChangePassword,
      resetPasswordUseCase: mockResetPassword,
      updateProfileUseCase: mockUpdateProfile,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, const AuthInitial());
    });

    test('currentUser returns null when not authenticated', () {
      expect(authCubit.currentUser, isNull);
    });

    test('isAuthenticated returns false when not authenticated', () {
      expect(authCubit.isAuthenticated, isFalse);
    });

    test('isLoading returns false initially', () {
      expect(authCubit.isLoading, isFalse);
    });
  });

  group('checkAuthStatus', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when user exists',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [const AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no user',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => const Right(null));
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [const AuthLoading(), const Unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] on failure',
      build: () {
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => const Left(ServerFailure('Session expired')));
        return authCubit;
      },
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [const AuthLoading(), const Unauthenticated()],
    );
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] on successful login',
      build: () {
        when(() => mockLogin(any())).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) =>
          cubit.login(email: 'test@example.com', password: 'password123'),
      expect: () => [const AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on invalid credentials',
      build: () {
        when(() => mockLogin(any())).thenAnswer(
          (_) async => const Left(AuthenticationFailure('Invalid credentials')),
        );
        return authCubit;
      },
      act: (cubit) =>
          cubit.login(email: 'test@example.com', password: 'wrongpassword'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on network error',
      build: () {
        when(
          () => mockLogin(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return authCubit;
      },
      act: (cubit) =>
          cubit.login(email: 'test@example.com', password: 'password123'),
      expect: () => [const AuthLoading(), const AuthError('Network error')],
    );

    blocTest<AuthCubit, AuthState>(
      'authenticates admin user successfully',
      build: () {
        when(() => mockLogin(any())).thenAnswer((_) async => Right(testAdmin));
        return authCubit;
      },
      act: (cubit) =>
          cubit.login(email: 'admin@example.com', password: 'admin123'),
      expect: () => [const AuthLoading(), Authenticated(testAdmin)],
      verify: (cubit) {
        expect(cubit.currentUser?.role, 'admin');
      },
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] on successful registration',
      build: () {
        when(
          () => mockRegister(any()),
        ).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'Test User',
        phone: '+201234567890',
      ),
      expect: () => [const AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when email already exists',
      build: () {
        when(() => mockRegister(any())).thenAnswer(
          (_) async =>
              const Left(AuthenticationFailure('Email already in use')),
        );
        return authCubit;
      },
      act: (cubit) => cubit.register(
        email: 'existing@example.com',
        password: 'password123',
        fullName: 'Test User',
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Email already in use'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on weak password',
      build: () {
        when(() => mockRegister(any())).thenAnswer(
          (_) async => const Left(ValidationFailure('Password too weak')),
        );
        return authCubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        password: '123',
        fullName: 'Test User',
      ),
      expect: () => [const AuthLoading(), const AuthError('Password too weak')],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] on successful logout',
      build: () {
        when(() => mockLogout()).thenAnswer((_) async => const Right(null));
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthLoading(), const Unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on logout failure',
      build: () {
        when(
          () => mockLogout(),
        ).thenAnswer((_) async => const Left(ServerFailure('Logout failed')));
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthLoading(), const AuthError('Logout failed')],
    );
  });

  group('resetPassword', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, PasswordResetEmailSent] on success',
      build: () {
        when(
          () => mockResetPassword(any()),
        ).thenAnswer((_) async => const Right(null));
        return authCubit;
      },
      act: (cubit) => cubit.resetPassword('test@example.com'),
      expect: () => [const AuthLoading(), const PasswordResetEmailSent()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when email not found',
      build: () {
        when(() => mockResetPassword(any())).thenAnswer(
          (_) async => const Left(AuthenticationFailure('Email not found')),
        );
        return authCubit;
      },
      act: (cubit) => cubit.resetPassword('nonexistent@example.com'),
      expect: () => [const AuthLoading(), const AuthError('Email not found')],
    );
  });

  group('updateProfile', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, ProfileUpdated, Authenticated] on success',
      build: () {
        final updatedUser = testUser.copyWith(fullName: 'Updated Name');
        when(
          () => mockUpdateProfile(any()),
        ).thenAnswer((_) async => Right(updatedUser));
        return authCubit;
      },
      act: (cubit) => cubit.updateProfile(fullName: 'Updated Name'),
      expect: () => [
        const AuthLoading(),
        isA<ProfileUpdated>(),
        isA<Authenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits error and restores auth status on failure',
      build: () {
        when(
          () => mockUpdateProfile(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.updateProfile(fullName: 'New Name'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Update failed'),
        const AuthLoading(),
        Authenticated(testUser),
      ],
    );
  });

  group('changePassword', () {
    blocTest<AuthCubit, AuthState>(
      'emits PasswordChanged on success',
      build: () {
        when(
          () => mockChangePassword(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.changePassword(
        currentPassword: 'oldpass',
        newPassword: 'newpass',
      ),
      expect: () => [
        const PasswordChanged(),
        const AuthLoading(),
        Authenticated(testUser),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthError on wrong current password',
      build: () {
        when(() => mockChangePassword(any())).thenAnswer(
          (_) async => const Left(AuthenticationFailure('Wrong password')),
        );
        when(
          () => mockGetCurrentUser(),
        ).thenAnswer((_) async => Right(testUser));
        return authCubit;
      },
      act: (cubit) => cubit.changePassword(
        currentPassword: 'wrongpass',
        newPassword: 'newpass',
      ),
      expect: () => [
        const AuthError('Wrong password'),
        const AuthLoading(),
        Authenticated(testUser),
      ],
    );
  });

  group('clearError', () {
    blocTest<AuthCubit, AuthState>(
      'emits Unauthenticated when in error state',
      build: () => authCubit,
      seed: () => const AuthError('Some error'),
      act: (cubit) => cubit.clearError(),
      expect: () => [const Unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'does nothing when not in error state',
      build: () => authCubit,
      seed: () => const Unauthenticated(),
      act: (cubit) => cubit.clearError(),
      expect: () => [],
    );
  });

  group('getters after authentication', () {
    test('currentUser returns user when authenticated', () async {
      when(() => mockLogin(any())).thenAnswer((_) async => Right(testUser));

      await authCubit.login(email: 'test@example.com', password: 'pass');

      expect(authCubit.currentUser, testUser);
      expect(authCubit.isAuthenticated, isTrue);
    });
  });
}
