import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Field information section displaying name, location, and verified badge.
///
/// Shows the field name with optional verified badge, and location details
/// including city and field size.
class FieldCardInfo extends StatelessWidget {
  /// The name of the field
  final String fieldName;

  /// The city where the field is located
  final String city;

  /// The size of the field (e.g., "5v5", "7v7", "11v11")
  final String fieldSize;

  /// Whether the field is verified
  final bool isVerified;

  const FieldCardInfo({
    super.key,
    required this.fieldName,
    required this.city,
    required this.fieldSize,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and Verified Badge
        Row(
          children: [
            Expanded(
              child: Text(
                fieldName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVerified) ...[
              const SizedBox(width: 8),
              _buildVerifiedBadge(),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Location
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$city • $fieldSize',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the verified badge with gradient background
  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
