import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_cell_handler.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_header_row.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_hint_banner.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_day_row.dart';

/// Excel-style booking grid showing 7 days (rows) and time slots (columns).
///
/// Displays:
/// - Header with time slots as columns
/// - Day rows with time slot cells
/// - Horizontal scrolling to see all time slots
/// - Interactive cells for viewing/creating bookings
class BookingGrid extends StatelessWidget {
  final BookingTableLoaded state;

  const BookingGrid({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final hasBookings = state.bookingSlots.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
                // Header row with time slots
                BookingTableHeaderRow(state: state),

                // Divider
                Container(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),

                // Day rows (7 days: Sat-Fri)
                ...List.generate(
                  7,
                  (dayIndex) => BookingTableDayRow(
                    dayIndex: dayIndex,
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
