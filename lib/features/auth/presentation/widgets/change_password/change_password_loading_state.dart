import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Change password loading state widget.
///
/// Displays loading indicator while password change is in progress.
class ChangePasswordLoadingState extends StatelessWidget {
  const ChangePasswordLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(context.l10n.loading),
        ],
      ),
    );
  }
}
