import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Initials Avatar Widget
///
/// Theme-aware: adapts to light/dark mode.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double fontSize;

  const InitialsAvatar({required this.initials, this.fontSize = 40, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.headlineLargeBold.copyWith(
            fontSize: fontSize,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
