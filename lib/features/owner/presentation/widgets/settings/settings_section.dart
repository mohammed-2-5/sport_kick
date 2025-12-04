import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// A section container for settings items.
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

  static const double _borderRadius = 12.0;
  static const double _padding = 16.0;
  static const double _titleSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: _titleSpacing),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
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
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
