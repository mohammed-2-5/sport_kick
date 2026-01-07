import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/owner/presentation/cubit/booking_table/booking_table_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/booking_table_helpers.dart';
import 'package:spo_kick/features/owner/presentation/widgets/booking_table/booking_table_header_row/time_column_header.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Header row for booking table showing TIME SLOTS across the top.
///
/// Displays time slots (09:00, 10:00, etc.) as columns with "Day" label first.
class BookingTableHeaderRow extends StatelessWidget {
  final BookingTableLoaded state;

  const BookingTableHeaderRow({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final hours = BookingTableHelpers.generateWorkingHours(state.businessHours);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Day column header (first cell)
        Container(
          width: 75,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            border: Border(
              right: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Text(
            context.l10n.dayLabel,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // Time columns headers
        ...hours.map((hour) => TimeColumnHeader(hour: hour)),
      ],
    );
  }
}
