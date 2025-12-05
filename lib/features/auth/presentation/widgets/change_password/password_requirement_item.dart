import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Password requirement item widget.
///
/// Displays a single password requirement with check/uncheck icon
/// based on whether the requirement is met.
class PasswordRequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordRequirementItem({
    required this.text,
    required this.isMet,
    super.key,
  });

  static const double _iconSize = 16.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: _iconSize,
            color: isMet ? AppColors.success : AppColors.lightGrey,
          ),
          const SizedBox(width: _spacing),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isMet ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
