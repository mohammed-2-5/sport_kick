import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Premium Section Title widget.
///
/// Features:
/// - Bold title text
/// - Proper styling for section headers
class PremiumSectionTitle extends StatelessWidget {
  /// Title text to display.
  final String title;

  const PremiumSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
