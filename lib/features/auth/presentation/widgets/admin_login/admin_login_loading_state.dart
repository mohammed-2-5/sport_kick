import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Admin login loading state widget.
///
/// Displays loading indicator while admin login is in progress.
class AdminLoginLoadingState extends StatelessWidget {
  const AdminLoginLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(context.l10n.loggingIn),
        ],
      ),
    );
  }
}
