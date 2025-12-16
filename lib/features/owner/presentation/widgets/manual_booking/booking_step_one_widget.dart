import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/owner/presentation/constants/owner_ui_constants.dart';
import 'package:spo_kick/features/owner/presentation/widgets/manual_booking/duration_selector.dart';

/// Step 1 of manual booking flow: Booking Details
///
/// Handles selection of:
/// - Field
/// - Date
/// - Duration (1 or 2 hours)
/// - Start Time
/// - Auto-calculated Total Price
class BookingStepOneWidget extends StatelessWidget {
  final FieldEntity? selectedField;
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final int durationHours;
  final double? totalPrice;
  final ValueChanged<FieldEntity?> onFieldChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<String?> onStartTimeChanged;
  final ValueChanged<String?> onEndTimeChanged;

  const BookingStepOneWidget({
    required this.selectedField,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.durationHours,
    required this.totalPrice,
    required this.onFieldChanged,
    required this.onDateChanged,
    required this.onDurationChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldsCubit, FieldsState>(
      builder: (context, state) {
        if (state is FieldsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FieldsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: OwnerUIConstants.spacingMedium),
                Text(state.message),
                const SizedBox(height: OwnerUIConstants.spacingMedium),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<FieldsCubit>().loadAllFields();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is FieldsLoaded) {
          final fields = state.fields;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(OwnerUIConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Details',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: OwnerUIConstants.spacingSmall),
                Text(
                  'Select field, date, time, and price',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Field selection
                Text(
                  'Select Field',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<FieldEntity>(
                    initialValue: selectedField,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      hintText: 'Choose a field',
                    ),
                    items: fields.map((field) {
                      return DropdownMenuItem(
                        value: field,
                        child: Text(field.name),
                      );
                    }).toList(),
                    onChanged: onFieldChanged,
                  ),
                ),

                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Date selection
                Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (date != null) {
                      onDateChanged(date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 12),
                        Text(
                          selectedDate == null
                              ? 'Choose a date'
                              : DateFormat(
                                  'EEEE, MMM d, y',
                                ).format(selectedDate!),
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedDate == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Duration selection
                Text(
                  'Booking Duration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DurationSelector(
                  selectedDuration: durationHours,
                  onDurationChanged: onDurationChanged,
                ),

                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Time slot selection
                Text(
                  'Start Time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTimeDropdown(
                  context,
                  'Select start time',
                  selectedStartTime,
                  onStartTimeChanged,
                ),

                // End time display (auto-calculated)
                if (selectedEndTime != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.navyDeep.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.navyDeep.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.navyDeep,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'End time: $selectedEndTime ($durationHours hour${durationHours > 1 ? 's' : ''})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.navyDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Calculated price display
                Text(
                  'Total Price',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: AppColors.goldAccent,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            totalPrice != null
                                ? '${totalPrice!.toStringAsFixed(0)} EGP'
                                : 'Select field to see price',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyDeep,
                            ),
                          ),
                          if (selectedField != null && totalPrice != null)
                            Text(
                              '${selectedField!.pricePerHour.toStringAsFixed(0)} EGP/hour × $durationHours hour${durationHours > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: OwnerUIConstants.spacingLarge),
              ],
            ),
          );
        }

        return const Center(child: Text('No fields available'));
      },
    );
  }

  Widget _buildTimeDropdown(
    BuildContext context,
    String label,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, bookingState) {
        List<String> timeSlots = [];

        // If time slots are loaded, use only available slots
        if (bookingState is TimeSlotsLoaded) {
          // Get available slots only
          timeSlots = bookingState.availableSlots
              .map((slot) => slot.startTime)
              .toList();
        } else {
          // Fallback: Generate all time slots from 06:00 to 23:00
          timeSlots = List.generate(
            18,
            (index) => '${(index + 6).toString().padLeft(2, '0')}:00',
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: timeSlots.map((time) {
              return DropdownMenuItem(
                value: time,
                child: Row(
                  children: [
                    Text(time),
                    if (bookingState is TimeSlotsLoaded)
                      const SizedBox(width: 8),
                    if (bookingState is TimeSlotsLoaded)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                  ],
                ),
              );
            }).toList(),
            onChanged: timeSlots.isEmpty ? null : onChanged,
            hint: Text(
              bookingState is BookingLoading
                  ? 'Loading slots...'
                  : (timeSlots.isEmpty ? 'No slots available' : 'Select time'),
            ),
          ),
        );
      },
    );
  }
}
