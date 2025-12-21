import 'package:flutter/material.dart';
import 'package:spo_kick/features/home/presentation/constants/home_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Role badge for the home welcome header.
class HomeRoleBadge extends StatelessWidget {
  final String role;

  const HomeRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HomeConstants.roleBadgePaddingHorizontal,
        vertical: HomeConstants.roleBadgePaddingVertical,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: HomeConstants.lowOpacity),
        borderRadius: BorderRadius.circular(
          HomeConstants.roleBadgeBorderRadius,
        ),
      ),
      child: Text(
        role.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontSize: HomeConstants.roleBadgeFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
