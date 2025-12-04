import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';

/// Card displaying top 3 performing fields based on booking count.
class TopFieldsCard extends StatelessWidget {
  const TopFieldsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerCubit, OwnerState>(
      builder: (context, ownerState) {
        return BlocBuilder<FieldsCubit, FieldsState>(
          builder: (context, fieldsState) {
            if (fieldsState is FieldsLoaded) {
              // Get bookings from owner state
              final bookings = ownerState is OwnerDataLoaded
                  ? ownerState.bookings
                  : (ownerState is OwnerBookingsLoaded
                        ? ownerState.bookings
                        : <BookingEntity>[]);

              // Calculate booking count for each field
              final fieldsWithCounts = fieldsState.fields.map((field) {
                final bookingCount = bookings
                    .where((booking) => booking.fieldId == field.id)
                    .length;
                return MapEntry(field, bookingCount);
              }).toList();

              // Sort by booking count descending
              fieldsWithCounts.sort((a, b) => b.value.compareTo(a.value));

              // Take top 3
              final topFields = fieldsWithCounts.take(3).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Performing Fields',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...topFields.asMap().entries.map((entry) {
                    final index = entry.key;
                    final fieldEntry = entry.value;
                    return _buildTopFieldItem(
                      index + 1,
                      fieldEntry.key.name,
                      fieldEntry.value,
                    );
                  }),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildTopFieldItem(int rank, String name, int bookings) {
    final gradients = [
      const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFE44D)],
      ), // Gold
      const LinearGradient(
        colors: [Color(0xFFC0C0C0), Color(0xFFE0E0E0)],
      ), // Silver
      const LinearGradient(
        colors: [Color(0xFFCD7F32), Color(0xFFE5A869)],
      ), // Bronze
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            gradients[rank - 1].colors.first.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gradients[rank - 1].colors.first.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradients[rank - 1],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradients[rank - 1].colors.first.withValues(
                    alpha: 0.4,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$bookings bookings',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
