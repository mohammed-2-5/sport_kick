import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_login_state.dart';

/// Cubit to manage Admin Login Screen state (Form, UI toggles)
class AdminLoginCubit extends Cubit<AdminLoginState> {
  AdminLoginCubit() : super(const AdminLoginState());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}
