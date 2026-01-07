import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/forgot_password_link.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_email_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_mode_selector.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_password_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_submit_button.dart';

/// Login form widget with email and password fields.
class LoginForm extends StatelessWidget {
  final Function(String)? onLoginModeChanged;

  const LoginForm({super.key, this.onLoginModeChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.loginMode != current.loginMode,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginModeSelector(
              currentMode: state.loginMode,
              onModeChanged: (mode) {
                context.read<LoginCubit>().changeLoginMode(mode);
                onLoginModeChanged?.call(mode);
              },
            ),
            const SizedBox(height: 24),
            const LoginEmailField(),
            const SizedBox(height: 16),
            const LoginPasswordField(),
            const SizedBox(height: 8),
            const ForgotPasswordLink(),
            const SizedBox(height: 24),
            const LoginSubmitButton(),
          ],
        );
      },
    );
  }
}
