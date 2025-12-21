import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/analytics/analytics_chart_card.dart';

/// Top performing fields list
class TopFieldsList extends StatelessWidget {
  final List<FieldEntity> fields;

  const TopFieldsList({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    // Sort fields by total bookings
    final sortedFields = fields.toList()
      ..sort((a, b) => b.totalBookings.compareTo(a.totalBookings));
    final topFields = sortedFields.take(5).toList();

    return AnalyticsChartCard(
      title: context.l10n.topPerformingFields,
      subtitle: context.l10n.byNumberOfBookings,
      icon: Icons.emoji_events,
      color: Colors.amber,
      child: Column(
        children: topFields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getRankColor(index),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Field info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        field.city,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${field.totalBookings}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (field.averageRating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            field.ratingDisplay,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.brown[300]!;
      default:
        return Colors.blue;
    }
  }
}
