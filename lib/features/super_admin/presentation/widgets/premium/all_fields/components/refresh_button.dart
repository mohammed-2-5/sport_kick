import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Refresh button widget for reloading fields data.
class AllFieldsRefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const AllFieldsRefreshButton({super.key, required this.onTap});

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
