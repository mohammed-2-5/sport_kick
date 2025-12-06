import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_stats_card.dart';

/// Displays statistics section for an admin based on their assigned fields.
class AdminStatisticsSection extends StatelessWidget {
  final UserEntity admin;

  const AdminStatisticsSection({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeXLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoaded) {
                final stats = _calculateStats(state.fields);
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Total Fields',
                            value: stats.totalFields.toString(),
                            icon: Icons.sports_soccer,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Active Fields',
                            value: stats.activeFields.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AdminUIConstants.listItemSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Total Bookings',
                            value: stats.totalBookings.toString(),
                            icon: Icons.event,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Avg Rating',
                            value: stats.avgRating > 0
                                ? stats.avgRating.toStringAsFixed(1)
                                : 'N/A',
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  _AdminStats _calculateStats(List<FieldEntity> allFields) {
    final adminFields = allFields
        .where((field) => field.ownerId == admin.id)
        .toList();

    final totalFields = adminFields.length;
    final activeFields = adminFields.where((f) => f.isActive).length;
    final totalBookings = adminFields.fold<int>(
      0,
      (sum, field) => sum + field.totalBookings,
    );

    final ratedFields = adminFields.where((f) => f.averageRating != null);
    final avgRating = ratedFields.isEmpty
        ? 0.0
        : ratedFields.map((f) => f.averageRating!).reduce((a, b) => a + b) /
              ratedFields.length;

    return _AdminStats(
      totalFields: totalFields,
      activeFields: activeFields,
      totalBookings: totalBookings,
      avgRating: avgRating,
    );
  }
}

class _AdminStats {
  final int totalFields;
  final int activeFields;
  final int totalBookings;
  final double avgRating;

  _AdminStats({
    required this.totalFields,
    required this.activeFields,
    required this.totalBookings,
    required this.avgRating,
  });
}
