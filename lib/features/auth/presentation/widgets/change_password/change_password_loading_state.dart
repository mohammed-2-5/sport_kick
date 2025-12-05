import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Change password loading state widget.
///
/// Displays loading indicator while password change is in progress.
class ChangePasswordLoadingState extends StatelessWidget {
  const ChangePasswordLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AuthConstants.formFieldSpacing),
          Text(AuthConstants.loadingChangePasswordMsg),
        ],
      ),
    );
  }
}
