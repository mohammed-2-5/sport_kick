import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void markEmailSent() {
    emit(state.copyWith(isEmailSent: true));
  }

  void resetState() {
    emit(const ForgotPasswordState());
  }
}
