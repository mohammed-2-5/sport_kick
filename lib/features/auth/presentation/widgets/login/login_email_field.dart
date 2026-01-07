import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Email input field for login form.
class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.email,
      hint: context.l10n.enterYourEmail,
      type: TextFieldType.email,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<LoginCubit>().updateEmail(value),
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
    );
  }
}
