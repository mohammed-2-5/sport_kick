import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/models/business_hours_update.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/business_hours_day_editor.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/sections/business_hours_days_grid.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/sections/business_hours_days_list.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/sections/business_hours_help_card.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/sections/business_hours_quick_actions.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/sections/business_hours_status_indicator.dart';

/// Loaded content for the Manage Business Hours page.
///
/// Displays business hours information, quick actions, and day editor.
class ManageBusinessHoursLoadedContent extends StatelessWidget {
  /// List of business hours entities
  final List<BusinessHoursEntity> businessHours;

  /// Whether the field is currently open (null if not checked)
  final bool? isCurrentlyOpen;

  /// Currently selected day for editing (-1 means none)
  final int selectedDay;

  /// Whether an update is in progress
  final bool updating;

  /// Callback when a day is selected
  final ValueChanged<int> onSelectDay;

  /// Callback when business hours are updated
  final Function(int dayOfWeek, BusinessHoursUpdate update)
  onUpdateBusinessHours;

  /// Callback to initialize default hours
  final VoidCallback onSetDefaultHours;

  /// Callback to show apply to all dialog
  final VoidCallback onApplyToAllDays;

  const ManageBusinessHoursLoadedContent({
    super.key,
    required this.businessHours,
    this.isCurrentlyOpen,
    required this.selectedDay,
    this.updating = false,
    required this.onSelectDay,
    required this.onUpdateBusinessHours,
    required this.onSetDefaultHours,
    required this.onApplyToAllDays,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isLargeScreen
                ? BusinessHoursConstants.sectionSpacing
                : BusinessHoursConstants.cardPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current status indicator
                  if (isCurrentlyOpen != null)
                    BusinessHoursStatusIndicator(isOpen: isCurrentlyOpen!),

                  if (isCurrentlyOpen != null)
                    const SizedBox(
                      height: BusinessHoursConstants.sectionSpacing,
                    ),

                  // Help text
                  const BusinessHoursHelpCard(),

                  const SizedBox(height: BusinessHoursConstants.sectionSpacing),

                  // Quick actions
                  BusinessHoursQuickActions(
                    onSetDefaultHours: onSetDefaultHours,
                    onApplyToAllDays: onApplyToAllDays,
                  ),

                  const SizedBox(height: BusinessHoursConstants.sectionSpacing),

                  // Days list/grid
                  if (isLargeScreen)
                    BusinessHoursDaysGrid(
                      businessHours: businessHours,
                      selectedDay: selectedDay,
                      onSelectDay: onSelectDay,
                      updating: updating,
                    )
                  else
                    BusinessHoursDaysList(
                      businessHours: businessHours,
                      selectedDay: selectedDay,
                      onSelectDay: onSelectDay,
                      updating: updating,
                    ),

                  // Editor section (shown when a day is selected)
                  if (selectedDay >= 0 &&
                      selectedDay < businessHours.length) ...[
                    const SizedBox(
                      height: BusinessHoursConstants.sectionSpacing,
                    ),
                    BusinessHoursDayEditor(
                      businessHours: businessHours[selectedDay],
                      onUpdate: (update) => onUpdateBusinessHours(
                        businessHours[selectedDay].dayOfWeek,
                        update,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
