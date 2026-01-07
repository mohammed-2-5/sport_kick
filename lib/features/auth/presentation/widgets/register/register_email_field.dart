import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Email input field for registration.
class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      label: context.l10n.email,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<RegisterCubit>().updateEmail(value),
      validator: (value) => value == null || !value.contains('@')
          ? context.l10n.invalidEmail
          : null,
    );
  }
}
