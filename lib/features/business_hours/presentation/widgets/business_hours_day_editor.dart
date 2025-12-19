import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/models/business_hours_update.dart';
import 'package:spo_kick/features/business_hours/presentation/utils/business_hours_validators.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_editor/business_hours_editor_header.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/day_editor/business_hours_editor_time_controls.dart';

/// Editor widget for modifying business hours for a specific day.
///
/// Provides controls for:
/// - Toggling open/closed status
/// - Selecting opening time
/// - Selecting closing time
/// Validates that opening time is before closing time.
class BusinessHoursDayEditor extends StatefulWidget {
  /// Business hours entity being edited
  final BusinessHoursEntity businessHours;

  /// Callback when hours are updated
  final ValueChanged<BusinessHoursUpdate> onUpdate;

  /// Whether to show the day name
  final bool showDayName;

  const BusinessHoursDayEditor({
    super.key,
    required this.businessHours,
    required this.onUpdate,
    this.showDayName = true,
  });

  @override
  State<BusinessHoursDayEditor> createState() => _BusinessHoursDayEditorState();
}

class _BusinessHoursDayEditorState extends State<BusinessHoursDayEditor> {
  late bool _isOpen;
  late String _openingTime;
  late String _closingTime;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.businessHours.isOpen;
    _openingTime =
        widget.businessHours.openingTime ??
        BusinessHoursConstants.defaultOpeningTime;
    _closingTime =
        widget.businessHours.closingTime ??
        BusinessHoursConstants.defaultClosingTime;
  }

  @override
  void didUpdateWidget(BusinessHoursDayEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.businessHours != widget.businessHours) {
      setState(() {
        _isOpen = widget.businessHours.isOpen;
        _openingTime =
            widget.businessHours.openingTime ??
            BusinessHoursConstants.defaultOpeningTime;
        _closingTime =
            widget.businessHours.closingTime ??
            BusinessHoursConstants.defaultClosingTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          BusinessHoursConstants.cardBorderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BusinessHoursConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with day name and open/closed toggle
            BusinessHoursEditorHeader(
              dayOfWeek: widget.businessHours.dayOfWeek,
              isOpen: _isOpen,
              onToggleChanged: (value) {
                setState(() => _isOpen = value);
                widget.onUpdate(
                  BusinessHoursUpdate(
                    isOpen: _isOpen,
                    openingTime: _openingTime,
                    closingTime: _closingTime,
                  ),
                );
              },
              showDayName: widget.showDayName,
            ),

            if (_isOpen) ...[
              const SizedBox(height: BusinessHoursConstants.sectionSpacing),
              BusinessHoursEditorTimeControls(
                openingTime: _openingTime,
                closingTime: _closingTime,
                onOpeningTimeChanged: (newTime) {
                  if (!BusinessHoursValidators.isTimeRangeValid(
                    newTime,
                    _closingTime,
                  )) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.businessHoursInvalidTimeRange,
                          ),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                    return;
                  }
                  setState(() => _openingTime = newTime);
                  widget.onUpdate(
                    BusinessHoursUpdate(
                      isOpen: _isOpen,
                      openingTime: _openingTime,
                      closingTime: _closingTime,
                    ),
                  );
                },
                onClosingTimeChanged: (newTime) {
                  if (!BusinessHoursValidators.isTimeRangeValid(
                    _openingTime,
                    newTime,
                  )) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.businessHoursInvalidTimeRange,
                          ),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                    return;
                  }
                  setState(() => _closingTime = newTime);
                  widget.onUpdate(
                    BusinessHoursUpdate(
                      isOpen: _isOpen,
                      openingTime: _openingTime,
                      closingTime: _closingTime,
                    ),
                  );
                },
                enabled: _isOpen,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
