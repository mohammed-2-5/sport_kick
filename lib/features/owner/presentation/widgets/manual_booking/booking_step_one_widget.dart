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

/// Step 1 of manual booking flow: Booking Details
///
/// Handles selection of:
/// - Field
/// - Date
/// - Start/End Time
/// - Total Price
class BookingStepOneWidget extends StatelessWidget {
  final FieldEntity? selectedField;
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final double? totalPrice;
  final ValueChanged<FieldEntity?> onFieldChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<String?> onStartTimeChanged;
  final ValueChanged<String?> onEndTimeChanged;
  final ValueChanged<double?> onPriceChanged;

  const BookingStepOneWidget({
    required this.selectedField,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.totalPrice,
    required this.onFieldChanged,
    required this.onDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onPriceChanged,
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

                // Time slot selection
                Text(
                  'Time Slot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeDropdown(
                        context,
                        'Start Time',
                        selectedStartTime,
                        onStartTimeChanged,
                      ),
                    ),
                    const SizedBox(width: OwnerUIConstants.spacingMedium),
                    Expanded(
                      child: _buildTimeDropdown(
                        context,
                        'End Time',
                        selectedEndTime,
                        onEndTimeChanged,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: OwnerUIConstants.spacingLarge),

                // Price input
                Text(
                  'Total Price (EGP)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: totalPrice?.toString() ?? '',
                  decoration: InputDecoration(
                    hintText: 'Enter price',
                    prefixIcon: const Icon(Icons.monetization_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    onPriceChanged(double.tryParse(value));
                  },
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
