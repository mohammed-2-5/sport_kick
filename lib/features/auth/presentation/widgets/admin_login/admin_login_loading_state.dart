import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

/// Admin login loading state widget.
///
/// Displays loading indicator while admin login is in progress.
class AdminLoginLoadingState extends StatelessWidget {
  const AdminLoginLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AuthConstants.formFieldSpacing),
          Text(AuthConstants.loadingLoginMsg),
        ],
      ),
    );
  }
}
