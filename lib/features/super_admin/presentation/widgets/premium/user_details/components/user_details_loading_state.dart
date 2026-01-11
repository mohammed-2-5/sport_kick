import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Loading state widget for user details view.
class UserDetailsLoadingState extends StatelessWidget {
  const UserDetailsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.premiumGold),
      ),
    );
  }
}
