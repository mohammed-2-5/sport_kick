import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/day_selector.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_duration_selector.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_time_slot_grid.dart';

/// Content widget for create recurring booking page.
class CreateRecurringContent extends StatelessWidget {
  final CreateRecurringState state;
  final List<BusinessHoursEntity> businessHours;
  final ValueChanged<int> onDaySelected;
  final ValueChanged<String> onTimeSelected;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onSubmit;

  const CreateRecurringContent({
    required this.state,
    required this.businessHours,
    required this.onDaySelected,
    required this.onTimeSelected,
    required this.onDurationChanged,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      final CreateRecurringEditing editing => _buildEditingContent(
        context,
        editing,
      ),
      CreateRecurringSubmitting() => _buildSubmittingContent(),
      CreateRecurringSuccess() => const SizedBox.shrink(), // Handled by dialog
      CreateRecurringError() => const SizedBox.shrink(), // Handled by snackbar
    };
  }

  Widget _buildEditingContent(
    BuildContext context,
    CreateRecurringEditing editingState,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Field info card
                _buildFieldCard(editingState),
                const SizedBox(height: 24),

                // Duration selector
                RecurringDurationSelector(
                  selectedDuration: editingState.durationHours,
                  pricePerHour: editingState.field.pricePerHour,
                  onDurationChanged: onDurationChanged,
                ),
                const SizedBox(height: 24),

                // Day selector
                DaySelector(
                  selectedDay: editingState.selectedDayOfWeek,
                  onDaySelected: onDaySelected,
                ),
                const SizedBox(height: 24),

                // Time slot grid
                RecurringTimeSlotGrid(
                  selectedDayOfWeek: editingState.selectedDayOfWeek,
                  selectedTime: editingState.selectedTime,
                  durationHours: editingState.durationHours,
                  businessHours: businessHours,
                  reservedSlots: editingState.reservedSlots,
                  onTimeSelected: onTimeSelected,
                ),

                // Error message
                if (editingState.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            editingState.errorMessage!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Summary card
                if (editingState.isValid) ...[
                  const SizedBox(height: 24),
                  _buildSummaryCard(editingState),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Bottom submit button
        _buildBottomButton(editingState),
      ],
    );
  }

  Widget _buildFieldCard(CreateRecurringEditing editingState) {
    final field = editingState.field;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Field image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: field.mainImage != null
                ? CachedNetworkImage(
                    imageUrl: field.mainImage!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: AppColors.navyDeep.withValues(alpha: 0.1),
                      child: const Icon(Icons.sports_soccer),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.navyDeep.withValues(alpha: 0.1),
                      child: const Icon(Icons.sports_soccer),
                    ),
                  )
                : Container(
                    width: 64,
                    height: 64,
                    color: AppColors.navyDeep.withValues(alpha: 0.1),
                    child: const Icon(Icons.sports_soccer),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyDeep,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${field.pricePerHour.toStringAsFixed(0)} EGP/hour',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Recurring badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_repeat_rounded,
                  size: 14,
                  color: AppColors.accentCyan,
                ),
                SizedBox(width: 4),
                Text(
                  'Weekly',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(CreateRecurringEditing editingState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.navyDeep,
            AppColors.navyDeep.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Weekly Reservation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'Day',
                  value: editingState.selectedDayName,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value:
                      '${editingState.selectedTime} - ${editingState.endTime}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.timer_outlined,
                  label: 'Duration',
                  value: '${editingState.durationHours} hour(s)',
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.payments_outlined,
                  label: 'Weekly Cost',
                  value:
                      '${editingState.pricePerBooking.toStringAsFixed(0)} EGP',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton(CreateRecurringEditing editingState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: editingState.isValid ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.textSecondary.withValues(
                alpha: 0.2,
              ),
              disabledForegroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Submit Request',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentCyan,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Submitting Request...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navyDeep,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please wait while we process your request',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
