import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/constants/analytics_constants.dart';

/// Loading state widget for analytics pages.
/// Displays a centered loading indicator with message.
class AnalyticsLoadingState extends StatelessWidget {
  final String? message;

  const AnalyticsLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final displayMessage = message ?? context.l10n.pleaseWait;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AnalyticsConstants.sectionSpacing),
          Text(displayMessage),
        ],
      ),
    );
  }
}
