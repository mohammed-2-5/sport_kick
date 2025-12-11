import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Field info widget displaying field image and name.
class BookingListItemFieldInfo extends StatelessWidget {
  final String fieldName;
  final String? fieldImage;

  const BookingListItemFieldInfo({
    super.key,
    required this.fieldName,
    this.fieldImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (fieldImage != null) ...[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                fieldImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _FieldImagePlaceholder(),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            fieldName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }
}

/// Private placeholder widget for field image.
class _FieldImagePlaceholder extends StatelessWidget {
  const _FieldImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.sports_soccer,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}
