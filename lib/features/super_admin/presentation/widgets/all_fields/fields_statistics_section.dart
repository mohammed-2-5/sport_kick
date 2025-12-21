import 'package:flutter/material.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/shared/stat_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Fields statistics section widget
///
/// Displays overview statistics for all fields including:
/// - Total fields count
/// - Active/inactive counts
/// - Total bookings
/// - Average rating
class FieldsStatisticsSection extends StatelessWidget {
  final List<FieldEntity> fields;

  const FieldsStatisticsSection({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    final activeFields = fields.where((f) => f.isActive).length;
    final inactiveFields = fields.length - activeFields;
    final totalBookings = fields.fold<int>(
      0,
      (sum, field) => sum + field.totalBookings,
    );
    final avgRating = fields.where((f) => f.averageRating != null).isEmpty
        ? 0.0
        : fields
                  .where((f) => f.averageRating != null)
                  .map((f) => f.averageRating!)
                  .reduce((a, b) => a + b) /
              fields.where((f) => f.averageRating != null).length;

    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.fieldsOverview,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: context.l10n.totalFields,
                  value: fields.length.toString(),
                  icon: Icons.sports_soccer,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: context.l10n.active,
                  value: activeFields.toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: context.l10n.inactive,
                  value: inactiveFields.toString(),
                  icon: Icons.cancel,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: context.l10n.totalBookings,
                  value: totalBookings.toString(),
                  icon: Icons.event,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          if (avgRating > 0) ...[
            const SizedBox(height: 12),
            StatCard(
              label: context.l10n.averageRating,
              value: avgRating.toStringAsFixed(1),
              icon: Icons.star,
              color: Colors.amber,
            ),
          ],
        ],
      ),
    );
  }
}
