import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/theme/theme_extensions.dart';

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
    final colorScheme = context.colors;

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
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
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
    final colorScheme = context.colors;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.sports_soccer, color: colorScheme.primary, size: 24),
    );
  }
}
