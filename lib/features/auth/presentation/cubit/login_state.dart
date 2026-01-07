part of 'login_cubit.dart';

/// Validation error types for login.
enum LoginValidationError {
  emailRequired,
  invalidEmail,
  passwordRequired,
  passwordTooShort,
}

class LoginState extends Equatable {
  final bool isPasswordVisible;
  final String loginMode; // 'user' or 'admin'
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool rememberMe;
  final String email;
  final String password;
  final String forgotPasswordEmail;
  final bool forgotPasswordSubmitted;
  final LoginValidationError? validationError;

  const LoginState({
    this.isPasswordVisible = false,
    this.loginMode = 'user',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.rememberMe = false,
    this.email = '',
    this.password = '',
    this.forgotPasswordEmail = '',
    this.forgotPasswordSubmitted = false,
    this.validationError,
  });

  LoginState copyWith({
    bool? isPasswordVisible,
    String? loginMode,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? rememberMe,
    String? email,
    String? password,
    String? forgotPasswordEmail,
    bool? forgotPasswordSubmitted,
    LoginValidationError? validationError,
    bool clearError = false,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      loginMode: loginMode ?? this.loginMode,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      rememberMe: rememberMe ?? this.rememberMe,
      email: email ?? this.email,
      password: password ?? this.password,
      forgotPasswordEmail: forgotPasswordEmail ?? this.forgotPasswordEmail,
      forgotPasswordSubmitted:
          forgotPasswordSubmitted ?? this.forgotPasswordSubmitted,
      validationError: clearError
          ? null
          : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [
    isPasswordVisible,
    loginMode,
    isEmailValid,
    isPasswordValid,
    rememberMe,
    email,
    password,
    forgotPasswordEmail,
    forgotPasswordSubmitted,
    validationError,
  ];
}
