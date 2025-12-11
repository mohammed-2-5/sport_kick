import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium Empty Fields Message widget.
///
/// Features:
/// - Centered message with icon
/// - Rounded container
class PremiumEmptyFieldsMessage extends StatelessWidget {
  const PremiumEmptyFieldsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.sports_soccer_rounded,
              size: 40,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 12),
            Text(
              'No field data available',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
