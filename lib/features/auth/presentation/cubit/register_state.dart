part of 'register_cubit.dart';

/// Validation error types for registration.
enum RegisterValidationError {
  fullNameRequired,
  invalidEmail,
  passwordTooShort,
  passwordsDoNotMatch,
}

/// State for registration form UI.
class RegisterState extends Equatable {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool acceptedTerms;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String email;
  final String phone;
  final RegisterValidationError? validationError;

  const RegisterState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.acceptedTerms = false,
    this.password = '',
    this.confirmPassword = '',
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.validationError,
  });

  RegisterState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? acceptedTerms,
    String? password,
    String? confirmPassword,
    String? fullName,
    String? email,
    String? phone,
    RegisterValidationError? validationError,
    bool clearError = false,
  }) {
    return RegisterState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      validationError: clearError
          ? null
          : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [
    isPasswordVisible,
    isConfirmPasswordVisible,
    acceptedTerms,
    password,
    confirmPassword,
    fullName,
    email,
    phone,
    validationError,
  ];
}
