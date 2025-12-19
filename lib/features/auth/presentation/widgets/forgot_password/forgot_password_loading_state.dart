import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Forgot password loading state widget.
///
/// Displays loading indicator while sending reset email.
class ForgotPasswordLoadingState extends StatelessWidget {
  const ForgotPasswordLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AuthConstants.formFieldSpacing),
          Text(context.l10n.sendingResetLink),
        ],
      ),
    );
  }
}
