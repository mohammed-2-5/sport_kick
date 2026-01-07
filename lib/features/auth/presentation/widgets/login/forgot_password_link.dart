import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/forgot_password_dialog.dart';

/// Forgot password link button.
class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.read<LoginCubit>().resetForgotPasswordState();
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<LoginCubit>(),
              child: const ForgotPasswordDialog(),
            ),
          );
        },
        child: Text(context.l10n.forgotPassword),
      ),
    );
  }
}
