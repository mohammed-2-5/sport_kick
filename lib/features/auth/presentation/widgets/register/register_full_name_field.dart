import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Full name input field for registration.
class RegisterFullNameField extends StatelessWidget {
  const RegisterFullNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      label: context.l10n.fullName,
      prefixIcon: Icons.person_outline,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<RegisterCubit>().updateFullName(value),
      validator: (value) =>
          value == null || value.isEmpty ? context.l10n.fieldRequired : null,
    );
  }
}
