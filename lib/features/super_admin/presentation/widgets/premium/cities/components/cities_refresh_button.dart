import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Refresh button for the header.
class CitiesRefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const CitiesRefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.refresh_rounded,
          color: AppColors.textOnNavy,
          size: 22,
        ),
        onPressed: onTap,
      ),
    );
  }
}
