import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

/// Phone input field for registration.
class RegisterPhoneField extends StatelessWidget {
  const RegisterPhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      label: context.l10n.phone,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      textInputAction: TextInputAction.next,
      onChanged: (value) => context.read<RegisterCubit>().updatePhone(value),
    );
  }
}
