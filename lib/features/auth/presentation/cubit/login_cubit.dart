import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

part 'login_state.dart';

/// Cubit to manage Login Screen state (Form, UI toggles)
///
/// Separates UI logical state from global Auth state.
class LoginCubit extends Cubit<LoginState> {
  final AuthCubit _authCubit;

  LoginCubit({required AuthCubit authCubit})
    : _authCubit = authCubit,
      super(const LoginState());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Change login mode (User/Admin)
  void changeLoginMode(String mode) {
    emit(state.copyWith(loginMode: mode));
  }

  /// Update email
  void updateEmail(String email) {
    emit(state.copyWith(email: email, clearError: true));
  }

  /// Update password
  void updatePassword(String password) {
    emit(state.copyWith(password: password, clearError: true));
  }

  /// Update email validity (called by form validation)
  void updateEmailValidity(bool isValid) {
    if (state.isEmailValid != isValid) {
      emit(state.copyWith(isEmailValid: isValid));
    }
  }

  /// Update password validity
  void updatePasswordValidity(bool isValid) {
    if (state.isPasswordValid != isValid) {
      emit(state.copyWith(isPasswordValid: isValid));
    }
  }

  /// Toggle "Remember Me"
  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  /// Clear validation error.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// Validate and submit login.
  void validateAndLogin() {
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    // Validate email
    if (state.email.isEmpty) {
      emit(state.copyWith(validationError: LoginValidationError.emailRequired));
      return;
    }

    if (!emailRegex.hasMatch(state.email.trim())) {
      emit(state.copyWith(validationError: LoginValidationError.invalidEmail));
      return;
    }

    // Validate password
    if (state.password.isEmpty) {
      emit(
        state.copyWith(validationError: LoginValidationError.passwordRequired),
      );
      return;
    }

    if (state.password.length < AppConstants.minPasswordLength) {
      emit(
        state.copyWith(validationError: LoginValidationError.passwordTooShort),
      );
      return;
    }

    // All validations passed - trigger haptic and login
    HapticFeedback.mediumImpact();
    _authCubit.login(
      email: state.email.trim(),
      password: state.password,
      loginMode: state.loginMode,
    );
  }

  /// Update forgot password email.
  void updateForgotPasswordEmail(String email) {
    emit(state.copyWith(forgotPasswordEmail: email, clearError: true));
  }

  /// Submit forgot password request.
  void submitForgotPassword() {
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (state.forgotPasswordEmail.isEmpty) {
      emit(state.copyWith(validationError: LoginValidationError.emailRequired));
      return;
    }

    if (!emailRegex.hasMatch(state.forgotPasswordEmail.trim())) {
      emit(state.copyWith(validationError: LoginValidationError.invalidEmail));
      return;
    }

    _authCubit.resetPassword(state.forgotPasswordEmail.trim());
    emit(state.copyWith(forgotPasswordSubmitted: true, clearError: true));
  }

  /// Reset forgot password state.
  void resetForgotPasswordState() {
    emit(
      state.copyWith(
        forgotPasswordEmail: '',
        forgotPasswordSubmitted: false,
        clearError: true,
      ),
    );
  }
}
