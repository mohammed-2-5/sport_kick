import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Premium email input field for login body.
class LoginBodyEmailField extends StatelessWidget {
  const LoginBodyEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isEmailValid != current.isEmailValid,
      builder: (context, state) {
        return PremiumTextField(
          label: context.l10n.email,
          hintText: context.l10n.enterYourEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          textInputAction: TextInputAction.next,
          errorText: !state.isEmailValid ? context.l10n.invalidEmail : null,
          onChanged: (value) => context.read<LoginCubit>().updateEmail(value),
        );
      },
    );
  }
}
