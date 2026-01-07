import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Password input field for registration.
class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return PremiumTextField(
          label: context.l10n.password,
          isPassword: true,
          obscureText: !state.isPasswordVisible,
          prefixIcon: Icons.lock_outline,
          textInputAction: TextInputAction.next,
          onTogglePassword: () =>
              context.read<RegisterCubit>().togglePasswordVisibility(),
          onChanged: (value) =>
              context.read<RegisterCubit>().updatePassword(value),
          validator: (value) => value == null || value.length < 6
              ? context.l10n.passwordRequirementText
              : null,
        );
      },
    );
  }
}
