import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Confirm password input field for registration.
class RegisterConfirmPasswordField extends StatelessWidget {
  const RegisterConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.isConfirmPasswordVisible != current.isConfirmPasswordVisible,
      builder: (context, state) {
        return PremiumTextField(
          label: context.l10n.confirmPassword,
          isPassword: true,
          obscureText: !state.isConfirmPasswordVisible,
          prefixIcon: Icons.lock_outline,
          textInputAction: TextInputAction.done,
          onTogglePassword: () =>
              context.read<RegisterCubit>().toggleConfirmPasswordVisibility(),
          onChanged: (value) =>
              context.read<RegisterCubit>().updateConfirmPassword(value),
          validator: (value) => value == null || value.isEmpty
              ? context.l10n.pleaseConfirmPassword
              : null,
        );
      },
    );
  }
}
