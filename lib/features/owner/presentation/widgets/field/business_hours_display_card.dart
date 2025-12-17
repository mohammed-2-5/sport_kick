import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_card.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_state.dart';

/// Premium business hours display card for field details.
///
/// Shows working hours for each day of the week in a compact format.
/// Groups consecutive days with same hours for cleaner display.
class BusinessHoursDisplayCard extends StatelessWidget {
  final String fieldId;
  final VoidCallback? onManage;

  const BusinessHoursDisplayCard({
    super.key,
    required this.fieldId,
    this.onManage,
  });

  /// Day names for display (Saturday first).
  static const _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  static const _fullDayNames = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BusinessHoursCubit>()..getFieldBusinessHours(fieldId: fieldId),
      child: BlocBuilder<BusinessHoursCubit, BusinessHoursState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PremiumCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    _buildContent(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        // Title
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Business Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Working schedule',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        // Manage button
        if (onManage != null)
          TextButton.icon(
            onPressed: onManage,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Manage'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accentCyan,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BusinessHoursState state) {
    if (state is BusinessHoursLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.accentCyan,
          ),
        ),
      );
    }

    if (state is BusinessHoursError) {
      return _buildErrorContent(state.message);
    }

    if (state is BusinessHoursLoaded) {
      return _buildHoursGrid(state.businessHours);
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorContent(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursGrid(List<BusinessHoursEntity> hours) {
    // Sort hours by day of week (0=Saturday to 6=Friday)
    final sortedHours = List<BusinessHoursEntity>.from(hours)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    return Column(
      children: sortedHours.map((hour) => _buildDayRow(hour)).toList(),
    );
  }

  Widget _buildDayRow(BusinessHoursEntity hour) {
    final isOpen = hour.isOpen;
    final dayName = hour.dayOfWeek < _fullDayNames.length
        ? _fullDayNames[hour.dayOfWeek]
        : 'Day ${hour.dayOfWeek}';
    final shortDay = hour.dayOfWeek < _dayNames.length
        ? _dayNames[hour.dayOfWeek]
        : 'D${hour.dayOfWeek}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.accentCyan.withValues(alpha: 0.05)
            : AppColors.textSecondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOpen
              ? AppColors.accentCyan.withValues(alpha: 0.2)
              : AppColors.textSecondary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          // Day badge
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isOpen ? AppColors.accentCyan : AppColors.textSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              shortDay,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Day name
          Expanded(
            child: Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isOpen ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          // Time range or Closed
          if (isOpen)
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimeRange(hour.openingTime, hour.closingTime),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Closed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Format time range string.
  String _formatTimeRange(String? openTime, String? closeTime) {
    if (openTime == null || closeTime == null) return 'N/A';

    final formattedOpen = _formatTime(openTime);
    final formattedClose = _formatTime(closeTime);
    return '$formattedOpen - $formattedClose';
  }

  /// Format time from HH:mm:ss to HH:mm.
  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }
}
