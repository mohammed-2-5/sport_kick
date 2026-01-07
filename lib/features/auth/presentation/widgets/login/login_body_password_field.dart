import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Premium password input field for login body.
class LoginBodyPasswordField extends StatelessWidget {
  const LoginBodyPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return PremiumTextField(
          label: context.l10n.password,
          hintText: context.l10n.enterPassword,
          isPassword: true,
          obscureText: !state.isPasswordVisible,
          prefixIcon: Icons.lock_outline,
          textInputAction: TextInputAction.done,
          onTogglePassword: () =>
              context.read<LoginCubit>().togglePasswordVisibility(),
          onChanged: (value) =>
              context.read<LoginCubit>().updatePassword(value),
        );
      },
    );
  }
}
