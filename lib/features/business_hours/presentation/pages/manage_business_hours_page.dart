import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_cubit.dart';
import 'package:spo_kick/features/business_hours/presentation/cubit/business_hours_state.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/dialogs/apply_to_all_days_dialog.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/page/manage_business_hours_app_bar.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/page/manage_business_hours_loaded_content.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/states/business_hours_empty_state.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/states/business_hours_error_state.dart';
import 'package:spo_kick/features/business_hours/presentation/widgets/states/business_hours_loading_state.dart';

/// Page for managing business hours for a field.
///
/// Allows field owners to view and edit operating hours for each day of the week.
/// Provides bulk actions like "Set Default Hours" and "Apply to All Days".
class ManageBusinessHoursPage extends StatefulWidget {
  /// The field ID for which to manage business hours
  final String fieldId;

  /// Optional field name to display in the title
  final String? fieldName;

  const ManageBusinessHoursPage({
    super.key,
    required this.fieldId,
    this.fieldName,
  });

  @override
  State<ManageBusinessHoursPage> createState() =>
      _ManageBusinessHoursPageState();
}

class _ManageBusinessHoursPageState extends State<ManageBusinessHoursPage> {
  /// Currently selected day for editing (-1 means none selected)
  int _selectedDay = -1;

  @override
  void initState() {
    super.initState();
    context.read<BusinessHoursCubit>().getFieldBusinessHours(
      fieldId: widget.fieldId,
      checkCurrentStatus: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManageBusinessHoursAppBar(
        fieldName: widget.fieldName,
        onRefresh: () =>
            context.read<BusinessHoursCubit>().getFieldBusinessHours(
              fieldId: widget.fieldId,
              checkCurrentStatus: true,
            ),
      ),
      body: BlocConsumer<BusinessHoursCubit, BusinessHoursState>(
        listener: (context, state) {
          final l10n = context.l10n;

          if (state is BusinessHoursUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? l10n.businessHoursUpdatedSuccess,
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() => _selectedDay = -1);
          }

          if (state is BusinessHoursError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: l10n.retry,
                  textColor: Colors.white,
                  onPressed: () =>
                      context.read<BusinessHoursCubit>().getFieldBusinessHours(
                        fieldId: widget.fieldId,
                        checkCurrentStatus: true,
                      ),
                ),
              ),
            );
          }

          if (state is BusinessHoursInitialized) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.businessHoursDefaultHoursSet),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BusinessHoursLoading ||
              state is BusinessHoursInitializing) {
            return const BusinessHoursLoadingState();
          }

          if (state is BusinessHoursError) {
            return BusinessHoursErrorState(
              message: state.message,
              onRetry: () =>
                  context.read<BusinessHoursCubit>().getFieldBusinessHours(
                    fieldId: widget.fieldId,
                    checkCurrentStatus: true,
                  ),
            );
          }

          if (state is BusinessHoursLoaded) {
            return ManageBusinessHoursLoadedContent(
              businessHours: state.businessHours,
              isCurrentlyOpen: state.isCurrentlyOpen,
              selectedDay: _selectedDay,
              updating: false,
              onSelectDay: (dayIndex) {
                setState(() {
                  _selectedDay = _selectedDay == dayIndex ? -1 : dayIndex;
                });
              },
              onUpdateBusinessHours: (dayOfWeek, update) {
                context.read<BusinessHoursCubit>().updateBusinessHours(
                  fieldId: widget.fieldId,
                  dayOfWeek: dayOfWeek,
                  isOpen: update.isOpen,
                  openingTime: update.openingTime,
                  closingTime: update.closingTime,
                );
              },
              onSetDefaultHours: () {
                context
                    .read<BusinessHoursCubit>()
                    .initializeDefaultBusinessHours(widget.fieldId);
              },
              onApplyToAllDays: () async {
                final confirmed = await ApplyToAllDaysDialog.show(context);
                if (!context.mounted) return;

                if (confirmed == true) {
                  // Apply default 24/7 hours to all days
                  context
                      .read<BusinessHoursCubit>()
                      .initializeDefaultBusinessHours(widget.fieldId);
                }
              },
            );
          }

          if (state is BusinessHoursUpdating) {
            return ManageBusinessHoursLoadedContent(
              businessHours: state.businessHours,
              isCurrentlyOpen: null,
              selectedDay: _selectedDay,
              updating: true,
              onSelectDay: (dayIndex) {
                setState(() {
                  _selectedDay = _selectedDay == dayIndex ? -1 : dayIndex;
                });
              },
              onUpdateBusinessHours: (dayOfWeek, update) {
                context.read<BusinessHoursCubit>().updateBusinessHours(
                  fieldId: widget.fieldId,
                  dayOfWeek: dayOfWeek,
                  isOpen: update.isOpen,
                  openingTime: update.openingTime,
                  closingTime: update.closingTime,
                );
              },
              onSetDefaultHours: () {
                context
                    .read<BusinessHoursCubit>()
                    .initializeDefaultBusinessHours(widget.fieldId);
              },
              onApplyToAllDays: () async {
                final confirmed = await ApplyToAllDaysDialog.show(context);
                if (!context.mounted) return;

                if (confirmed == true) {
                  context
                      .read<BusinessHoursCubit>()
                      .initializeDefaultBusinessHours(widget.fieldId);
                }
              },
            );
          }

          return BusinessHoursEmptyState(
            onInitializeDefaultHours: () {
              context.read<BusinessHoursCubit>().initializeDefaultBusinessHours(
                widget.fieldId,
              );
            },
          );
        },
      ),
    );
  }
}
