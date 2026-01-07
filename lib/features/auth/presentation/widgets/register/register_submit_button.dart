import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Register submit button with validation error listener.
class RegisterSubmitButton extends StatelessWidget {
  const RegisterSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>
          previous.validationError != current.validationError &&
          current.validationError != null,
      listener: (context, state) {
        if (state.validationError != null) {
          final message = _getLocalizedError(context, state.validationError!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<RegisterCubit>().clearError();
        }
      },
      child: PremiumButton(
        label: context.l10n.createAccount,
        onPressed: () => context.read<RegisterCubit>().validateAndRegister(),
        icon: Icons.person_add,
      ),
    );
  }

  String _getLocalizedError(
    BuildContext context,
    RegisterValidationError error,
  ) {
    switch (error) {
      case RegisterValidationError.fullNameRequired:
        return context.l10n.fieldRequired;
      case RegisterValidationError.invalidEmail:
        return context.l10n.invalidEmail;
      case RegisterValidationError.passwordTooShort:
        return context.l10n.passwordRequirementText;
      case RegisterValidationError.passwordsDoNotMatch:
        return context.l10n.passwordsDoNotMatch;
    }
  }
}
