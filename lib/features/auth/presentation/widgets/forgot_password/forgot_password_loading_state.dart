import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Forgot password loading state widget.
///
/// Displays loading indicator while sending reset email.
class ForgotPasswordLoadingState extends StatelessWidget {
  const ForgotPasswordLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AuthConstants.formFieldSpacing),
          Text(AuthConstants.loadingResetPasswordMsg),
        ],
      ),
    );
  }
}
