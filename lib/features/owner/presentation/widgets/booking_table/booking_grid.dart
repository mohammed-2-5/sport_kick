import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_cell_handler.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_header_row.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_hint_banner.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_hour_row.dart';

/// Excel-style booking grid showing 7 days and working hours.
///
/// Displays:
/// - Header with day names and dates
/// - Hourly time slots with booking status
/// - Horizontal scrolling to see all 7 days
/// - Interactive cells for viewing/creating bookings
class BookingGrid extends StatelessWidget {
  final BookingTableLoaded state;

  const BookingGrid({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final hours = BookingTableHelpers.generateWorkingHours(state.businessHours);
    final hasBookings = state.bookingSlots.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scroll hint or empty state
          BookingTableHintBanner(hasBookings: hasBookings),

          // Scrollable grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // Header row with day names
                BookingTableHeaderRow(state: state),

                // Divider
                Container(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.3),
                ),

                // Hour rows
                ...hours.map(
                  (hour) => BookingTableHourRow(
                    hour: hour,
                    state: state,
                    onCellTap: (dayIndex, hour) {
                      BookingTableCellHandler.onCellTap(
                        context: context,
                        state: state,
                        dayIndex: dayIndex,
                        hour: hour,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
