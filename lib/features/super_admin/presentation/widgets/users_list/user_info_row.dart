import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Simple row displaying an icon and a single line of text.
class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const UserInfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
