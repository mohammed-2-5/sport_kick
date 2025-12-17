import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';

/// Handler for booking table cell tap interactions.
///
/// Coordinates navigation based on cell state:
/// - Empty open slot → Navigate to manual booking
/// - Booked slot → Navigate to booking details
/// - Closed slot → Show error message
class BookingTableCellHandler {
  BookingTableCellHandler._();

  /// Handle cell tap event.
  static void onCellTap({
    required BuildContext context,
    required BookingTableLoaded state,
    required int dayIndex,
    required String hour,
  }) {
    final booking = state.getBookingAt(dayIndex, hour);
    final slotDate = state.weekStartDate.add(Duration(days: dayIndex));

    if (booking != null) {
      // Always allow viewing booking details (past or future)
      _navigateToBookingDetails(context, booking);
    } else {
      // Check if slot is in the past
      final isPast = _isSlotInPast(slotDate, hour);

      if (isPast) {
        // Show message that slot is in the past
        _showPastSlotMessage(context);
        return;
      }

      // Check if slot is open
      final businessHours = state.getBusinessHoursForDay(dayIndex);
      final isOpen = BookingTableHelpers.isHourOpen(hour, businessHours);

      if (isOpen) {
        // Navigate to create manual booking
        _navigateToManualBooking(context, state, dayIndex, hour);
      } else {
        // Show message that field is closed
        _showClosedMessage(context);
      }
    }
  }

  /// Navigate to booking details page.
  static void _navigateToBookingDetails(
    BuildContext context,
    BookingEntity booking,
  ) {
    context.pushNamed('ownerBookingDetail', extra: booking);
  }

  /// Navigate to manual booking creation page.
  static void _navigateToManualBooking(
    BuildContext context,
    BookingTableLoaded state,
    int dayIndex,
    String hour,
  ) {
    final date = state.weekStartDate.add(Duration(days: dayIndex));
    final fieldId = state.selectedField.id;
    final fieldName = state.selectedField.name;

    // Pass initial data via extra
    context.pushNamed(
      'ownerCreateManualBooking',
      extra: {
        'fieldId': fieldId,
        'fieldName': fieldName,
        'selectedDate': date,
        'selectedTime': hour,
      },
    );
  }

  /// Show snackbar for closed time slot.
  static void _showClosedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Field is closed at this time'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show snackbar for past time slot.
  static void _showPastSlotMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cannot create bookings for past dates'),
        backgroundColor: AppColors.textSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Check if a time slot is in the past.
  static bool _isSlotInPast(DateTime date, String hour) {
    final hourInt = int.parse(hour.split(':')[0]);
    final minuteInt = int.parse(hour.split(':')[1]);

    final slotDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hourInt,
      minuteInt,
    );

    return slotDateTime.isBefore(DateTime.now());
  }
}
