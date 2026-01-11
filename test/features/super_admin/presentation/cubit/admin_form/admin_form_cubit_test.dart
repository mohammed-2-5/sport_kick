import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/create_admin_account_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_state.dart';

// Mock Use Cases
class MockCreateAdminAccountUseCase extends Mock
    implements CreateAdminAccountUseCase {}

void main() {
  late AdminFormCubit cubit;
  late MockCreateAdminAccountUseCase mockCreateAdmin;

  // Test data
  final testInvitation = AdminInvitationEntity(
    id: 'invitation-1',
    adminId: 'admin-1',
    email: 'test@example.com',
    fullName: 'Test Admin',
    defaultPassword: 'password123',
    createdBy: 'super-admin-1',
    status: AdminInvitationStatus.pending,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockCreateAdmin = MockCreateAdminAccountUseCase();
    cubit = AdminFormCubit(createAdminAccountUseCase: mockCreateAdmin);
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminFormCubit', () {
    test('initial state is AdminFormData with empty fields', () {
      expect(cubit.state, isA<AdminFormData>());
      final state = cubit.state as AdminFormData;
      expect(state.email, '');
      expect(state.fullName, '');
      expect(state.phone, '');
      expect(state.isValid, false);
    });
  });

  group('updateEmail', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'validates empty email shows error',
      build: () => cubit,
      act: (cubit) => cubit.updateEmail(''),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.email, 'email', '')
            .having((s) => s.emailError, 'emailError', 'Email is required'),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'validates invalid email format shows error',
      build: () => cubit,
      act: (cubit) => cubit.updateEmail('invalid-email'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.email, 'email', 'invalid-email')
            .having(
              (s) => s.emailError,
              'emailError',
              'Please enter a valid email',
            ),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'validates valid email clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateEmail('valid@email.com'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.email, 'email', 'valid@email.com')
            .having((s) => s.emailError, 'emailError', isNull),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'does nothing when not in AdminFormData state',
      build: () => cubit,
      seed: () => AdminFormSubmitting(
        email: 'test@test.com',
        fullName: 'Test',
        phone: '',
      ),
      act: (cubit) => cubit.updateEmail('new@email.com'),
      expect: () => [],
    );
  });

  group('updateFullName', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'validates empty name shows error',
      build: () => cubit,
      act: (cubit) => cubit.updateFullName(''),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.fullName, 'fullName', '')
            .having((s) => s.nameError, 'nameError', 'Full name is required'),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'validates short name shows error',
      build: () => cubit,
      act: (cubit) => cubit.updateFullName('AB'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.fullName, 'fullName', 'AB')
            .having(
              (s) => s.nameError,
              'nameError',
              'Name must be at least 3 characters',
            ),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'validates valid name clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateFullName('John Doe'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.fullName, 'fullName', 'John Doe')
            .having((s) => s.nameError, 'nameError', isNull),
      ],
    );
  });

  group('updatePhone', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'validates invalid phone shows error',
      build: () => cubit,
      act: (cubit) => cubit.updatePhone('123'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.phone, 'phone', '123')
            .having(
              (s) => s.phoneError,
              'phoneError',
              'Please enter a valid phone number',
            ),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'validates valid phone clears error',
      build: () => cubit,
      act: (cubit) => cubit.updatePhone('+20 123 456 7890'),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.phone, 'phone', '+20 123 456 7890')
            .having((s) => s.phoneError, 'phoneError', isNull),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'allows empty phone (optional field)',
      build: () => cubit,
      act: (cubit) => cubit.updatePhone(''),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.phone, 'phone', '')
            .having((s) => s.phoneError, 'phoneError', isNull),
      ],
    );
  });

  group('form validation', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'isValid is true when email and name are valid',
      build: () => cubit,
      act: (cubit) {
        cubit.updateEmail('valid@email.com');
        cubit.updateFullName('John Doe');
      },
      expect: () => [
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', true),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'isValid is false when email is invalid',
      build: () => cubit,
      act: (cubit) {
        cubit.updateFullName('John Doe');
        cubit.updateEmail('invalid');
      },
      expect: () => [
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'isValid is false when name is too short',
      build: () => cubit,
      act: (cubit) {
        cubit.updateEmail('valid@email.com');
        cubit.updateFullName('AB');
      },
      expect: () => [
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'isValid is true with optional valid phone',
      build: () => cubit,
      act: (cubit) {
        cubit.updateEmail('valid@email.com');
        cubit.updateFullName('John Doe');
        cubit.updatePhone('+20 123 456 7890');
      },
      expect: () => [
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', false),
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', true),
        isA<AdminFormData>().having((s) => s.isValid, 'isValid', true),
      ],
    );
  });

  group('submit', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'does not submit when form is invalid',
      build: () => cubit,
      act: (cubit) => cubit.submit(),
      expect: () => [],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'emits [Submitting, Success] when submission succeeds',
      build: () {
        when(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: null,
          ),
        ).thenAnswer((_) async => Right(testInvitation));
        return cubit;
      },
      seed: () => const AdminFormData(
        email: 'test@example.com',
        fullName: 'Test Admin',
        phone: '',
        isValid: true,
      ),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<AdminFormSubmitting>().having(
          (s) => s.email,
          'email',
          'test@example.com',
        ),
        isA<AdminFormSuccess>().having(
          (s) => s.invitation.adminId,
          'adminId',
          'admin-1',
        ),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'emits [Submitting, Error] when submission fails',
      build: () {
        when(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: null,
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Email already exists')),
        );
        return cubit;
      },
      seed: () => const AdminFormData(
        email: 'test@example.com',
        fullName: 'Test Admin',
        phone: '',
        isValid: true,
      ),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<AdminFormSubmitting>(),
        isA<AdminFormError>()
            .having((s) => s.message, 'message', 'Email already exists')
            .having((s) => s.email, 'email', 'test@example.com'),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'submits with phone when provided',
      build: () {
        when(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: '+20123456789',
          ),
        ).thenAnswer((_) async => Right(testInvitation));
        return cubit;
      },
      seed: () => const AdminFormData(
        email: 'test@example.com',
        fullName: 'Test Admin',
        phone: '+20123456789',
        isValid: true,
      ),
      act: (cubit) => cubit.submit(),
      verify: (_) {
        verify(
          () => mockCreateAdmin(
            email: 'test@example.com',
            fullName: 'Test Admin',
            phone: '+20123456789',
          ),
        ).called(1);
      },
    );
  });

  group('reset', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'resets to initial form data',
      build: () => cubit,
      seed: () => const AdminFormData(
        email: 'test@example.com',
        fullName: 'Test Admin',
        phone: '+20123456789',
        isValid: true,
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.email, 'email', '')
            .having((s) => s.fullName, 'fullName', '')
            .having((s) => s.phone, 'phone', '')
            .having((s) => s.isValid, 'isValid', false),
      ],
    );
  });

  group('restoreFromError', () {
    blocTest<AdminFormCubit, AdminFormState>(
      'restores form data from error state',
      build: () => cubit,
      seed: () => const AdminFormError(
        message: 'Error occurred',
        email: 'test@example.com',
        fullName: 'Test Admin',
        phone: '+20123456789',
      ),
      act: (cubit) => cubit.restoreFromError(),
      expect: () => [
        isA<AdminFormData>()
            .having((s) => s.email, 'email', 'test@example.com')
            .having((s) => s.fullName, 'fullName', 'Test Admin')
            .having((s) => s.phone, 'phone', '+20123456789')
            .having((s) => s.isValid, 'isValid', true),
      ],
    );

    blocTest<AdminFormCubit, AdminFormState>(
      'does nothing when not in error state',
      build: () => cubit,
      act: (cubit) => cubit.restoreFromError(),
      expect: () => [],
    );
  });

  group('AdminFormSuccess', () {
    test('successMessage returns formatted message', () {
      final state = AdminFormSuccess(testInvitation);
      expect(state.successMessage, contains('Admin created successfully!'));
      expect(state.successMessage, contains('test@example.com'));
      expect(state.successMessage, contains('password123'));
    });
  });
}
