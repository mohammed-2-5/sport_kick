part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool isPasswordVisible;
  final String loginMode; // 'user' or 'admin'
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool rememberMe;

  const LoginState({
    this.isPasswordVisible = false,
    this.loginMode = 'user',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.rememberMe = false,
  });

  LoginState copyWith({
    bool? isPasswordVisible,
    String? loginMode,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? rememberMe,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      loginMode: loginMode ?? this.loginMode,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object> get props => [
    isPasswordVisible,
    loginMode,
    isEmailValid,
    isPasswordValid,
    rememberMe,
  ];
}
