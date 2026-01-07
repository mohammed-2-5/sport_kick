import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Premium login submit button for login body.
class LoginBodySubmitButton extends StatelessWidget {
  const LoginBodySubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.validationError != current.validationError &&
          current.validationError != null,
      listener: (context, state) {
        if (state.validationError != null) {
          final message = _getLocalizedError(context, state.validationError!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<LoginCubit>().clearError();
        }
      },
      child: PremiumButton(
        label: context.l10n.login,
        onPressed: () => context.read<LoginCubit>().validateAndLogin(),
        icon: Icons.login,
      ),
    );
  }

  String _getLocalizedError(BuildContext context, LoginValidationError error) {
    switch (error) {
      case LoginValidationError.emailRequired:
        return context.l10n.fieldRequired;
      case LoginValidationError.invalidEmail:
        return context.l10n.invalidEmail;
      case LoginValidationError.passwordRequired:
        return context.l10n.fieldRequired;
      case LoginValidationError.passwordTooShort:
        return context.l10n.passwordTooShort;
    }
  }
}
