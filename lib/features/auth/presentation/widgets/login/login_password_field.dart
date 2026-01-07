import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Password input field for login form.
class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.password,
      hint: context.l10n.enterPassword,
      type: TextFieldType.password,
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.done,
      onChanged: (value) => context.read<LoginCubit>().updatePassword(value),
      onSubmitted: (_) => context.read<LoginCubit>().validateAndLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.fieldRequired;
        }
        if (value.length < AppConstants.minPasswordLength) {
          return context.l10n.passwordTooShort;
        }
        return null;
      },
    );
  }
}
