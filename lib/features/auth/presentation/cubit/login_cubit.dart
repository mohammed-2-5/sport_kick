import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

/// Cubit to manage Login Screen state (Form, UI toggles)
///
/// Separates UI logical state from global Auth state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Change login mode (User/Admin)
  void changeLoginMode(String mode) {
    emit(state.copyWith(loginMode: mode));
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
}
