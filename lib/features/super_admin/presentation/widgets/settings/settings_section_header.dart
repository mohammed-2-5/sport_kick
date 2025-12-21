import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SettingsSectionHeader({
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.withColor(
            AppTextStyles.titleMediumBold,
            Colors.grey[800]!,
          ),
        ),
      ],
    );
  }
}
