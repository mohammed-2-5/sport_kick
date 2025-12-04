import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';

/// Settings Section Widget
///
/// Displays a titled section with a card containing child widgets.
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            bottom: SettingsConstants.titleBottomPadding,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: SettingsConstants.sectionIconSize,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SettingsConstants.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(SettingsConstants.sectionPadding),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
