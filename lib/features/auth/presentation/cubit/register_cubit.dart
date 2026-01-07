import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

part 'register_state.dart';

/// Cubit to manage Registration form UI state.
///
/// Handles password visibility, terms acceptance, form validation and registration.
class RegisterCubit extends Cubit<RegisterState> {
  final AuthCubit _authCubit;

  RegisterCubit({required AuthCubit authCubit})
    : _authCubit = authCubit,
      super(const RegisterState());

  /// Toggle password visibility.
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Toggle confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  /// Toggle terms acceptance.
  void toggleTermsAccepted() {
    emit(state.copyWith(acceptedTerms: !state.acceptedTerms));
  }

  /// Update password for strength indicator.
  void updatePassword(String password) {
    emit(state.copyWith(password: password, clearError: true));
  }

  /// Update confirm password.
  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword, clearError: true));
  }

  /// Update full name.
  void updateFullName(String fullName) {
    emit(state.copyWith(fullName: fullName, clearError: true));
  }

  /// Update email.
  void updateEmail(String email) {
    emit(state.copyWith(email: email, clearError: true));
  }

  /// Update phone.
  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone, clearError: true));
  }

  /// Clear validation error.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// Validate and submit registration.
  void validateAndRegister() {
    // Validate full name
    if (state.fullName.isEmpty) {
      emit(
        state.copyWith(
          validationError: RegisterValidationError.fullNameRequired,
        ),
      );
      return;
    }

    // Validate email
    if (state.email.isEmpty || !state.email.contains('@')) {
      emit(
        state.copyWith(validationError: RegisterValidationError.invalidEmail),
      );
      return;
    }

    // Validate password
    if (state.password.length < 6) {
      emit(
        state.copyWith(
          validationError: RegisterValidationError.passwordTooShort,
        ),
      );
      return;
    }

    // Validate password match
    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(
          validationError: RegisterValidationError.passwordsDoNotMatch,
        ),
      );
      return;
    }

    // All validations passed - trigger haptic and register
    HapticFeedback.mediumImpact();
    _authCubit.register(
      email: state.email.trim(),
      password: state.password,
      fullName: state.fullName.trim(),
      phone: state.phone.trim(),
    );
  }
}
