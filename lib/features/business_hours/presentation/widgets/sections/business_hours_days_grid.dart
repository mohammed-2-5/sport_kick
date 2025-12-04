import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/business_hours_day_card.dart';

/// Grid view widget displaying business hours for all days.
///
/// Shows a 2-column grid layout optimized for tablets and larger screens.
class BusinessHoursDaysGrid extends StatelessWidget {
  /// List of business hours for all 7 days
  final List<BusinessHoursEntity> businessHours;

  /// Index of currently selected day (-1 if none)
  final int selectedDay;

  /// Callback when a day is selected
  final ValueChanged<int> onSelectDay;

  /// Whether updates are in progress (disables interaction)
  final bool updating;

  const BusinessHoursDaysGrid({
    super.key,
    required this.businessHours,
    required this.selectedDay,
    required this.onSelectDay,
    this.updating = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: BusinessHoursConstants.itemSpacing,
        mainAxisSpacing: BusinessHoursConstants.itemSpacing,
      ),
      itemCount: businessHours.length,
      itemBuilder: (context, index) {
        return BusinessHoursDayCard(
          businessHours: businessHours[index],
          isSelected: selectedDay == index,
          onTap: updating ? null : () => onSelectDay(index),
        );
      },
    );
  }
}
