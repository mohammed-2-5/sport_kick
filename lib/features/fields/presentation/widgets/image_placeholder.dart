import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/constants/field_constants.dart';

/// Placeholder widget for when no images are available.
class ImagePlaceholder extends StatelessWidget {
  final String? message;

  const ImagePlaceholder({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_soccer,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: FieldConstants.standardPadding),
            Text(
              message ?? 'No Images Available',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
