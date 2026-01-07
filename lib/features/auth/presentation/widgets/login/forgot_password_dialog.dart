import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Dialog for forgot password functionality.
class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.forgotPasswordSubmitted != current.forgotPasswordSubmitted ||
          (previous.validationError != current.validationError &&
              current.validationError != null),
      listener: (context, state) {
        if (state.forgotPasswordSubmitted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.resetEmailSentMessage)),
          );
        } else if (state.validationError != null) {
          final message = _getLocalizedError(context, state.validationError!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          context.read<LoginCubit>().clearError();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(context.l10n.resetPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.resetPasswordSubtitle),
              const SizedBox(height: 16),
              CustomTextField(
                label: context.l10n.email,
                hint: context.l10n.enterYourEmail,
                type: TextFieldType.email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) =>
                    context.read<LoginCubit>().updateForgotPasswordEmail(value),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.fieldRequired;
                  }
                  final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!regex.hasMatch(value.trim())) {
                    return context.l10n.invalidEmail;
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            CustomButton(
              text: context.l10n.resetPassword,
              onPressed: () =>
                  context.read<LoginCubit>().submitForgotPassword(),
              variant: ButtonVariant.primary,
            ),
          ],
        );
      },
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
