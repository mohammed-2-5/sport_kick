import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Filter button widget for the search bar.
///
/// Displays a filter icon button with premium shadow styling.
class FieldsFilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FieldsFilterButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(icon: const Icon(Icons.tune), onPressed: onPressed),
    );
  }
}
