import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Report Card Widget
///
/// Displays a report section with:
/// - Colored icon container
/// - Title and description
/// - Optional count badge
/// - Chevron indicator for navigation
/// - Haptic feedback on tap
///
/// Used to navigate to different report sections
class ReportCard extends StatelessWidget {
  /// Title of the report
  final String title;

  /// Description/subtitle of the report
  final String description;

  /// Icon to display in the card
  final IconData icon;

  /// Color theme for the icon and badge
  final Color color;

  /// Optional count or metric to display in badge
  final String? count;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Builder(
        builder: (context) {
          final cardColor = Theme.of(context).colorScheme.surface;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bold(AppTextStyles.titleMedium),
                      ),
                      const SizedBox(height: 4),
                      Text(description, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                if (count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      count!,
                      style: AppTextStyles.bold(
                        AppTextStyles.withColor(
                          AppTextStyles.labelMedium,
                          color,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
