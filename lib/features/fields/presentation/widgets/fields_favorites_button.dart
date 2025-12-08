import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Favorites button for field screens.
///
/// White icon button for navigating to favorites page.
class FieldsFavoritesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FieldsFavoritesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.favorite_border, color: AppColors.textOnNavy),
      onPressed: onPressed,
    );
  }
}
