import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double fontSize;

  const InitialsAvatar({required this.initials, this.fontSize = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
