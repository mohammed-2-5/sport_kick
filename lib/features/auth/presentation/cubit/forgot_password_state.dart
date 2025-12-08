part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final bool isEmailSent;
  final String email;

  const ForgotPasswordState({this.isEmailSent = false, this.email = ''});

  ForgotPasswordState copyWith({bool? isEmailSent, String? email}) {
    return ForgotPasswordState(
      isEmailSent: isEmailSent ?? this.isEmailSent,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [isEmailSent, email];
}
