import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/owner/presentation/models/time_slot_ui_model.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/date_selector.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_dropdown_field.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_field.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_time_slot_grid.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class ManualBookingStepOne extends StatelessWidget {
  final AppLocalizations l10n;
  final FieldEntity? selectedField;
  final ValueChanged<FieldEntity?> onFieldChanged;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final List<TimeSlotUiModel> timeSlots;
  final String? selectedTimeSlotId;
  final ValueChanged<String> onTimeSlotSelected;
  final TextEditingController priceController;

  const ManualBookingStepOne({
    super.key,
    required this.l10n,
    required this.selectedField,
    required this.onFieldChanged,
    required this.selectedDate,
    required this.onDateChanged,
    required this.timeSlots,
    required this.selectedTimeSlotId,
    required this.onTimeSlotSelected,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Field Selection
          PremiumFormSection(
            title: l10n.selectField,
            icon: Icons.sports_soccer,
            children: [
              BlocBuilder<FieldsCubit, FieldsState>(
                builder: (context, state) {
                  List<FieldEntity> fields = [];
                  if (state is FieldsLoaded) {
                    fields = state.fields;
                  }

                  if (fields.isEmpty) {
                    return Center(child: Text(l10n.noFieldsAvailable));
                  }

                  return PremiumDropdownField<FieldEntity>(
                    label: l10n.fieldLabel,
                    value: selectedField ?? fields.first,
                    items: fields,
                    itemLabel: (field) => field.name,
                    onChanged: (field) {
                      onFieldChanged(field);
                      if (field != null) {
                        priceController.text = field.pricePerHour
                            .toStringAsFixed(0);
                      }
                    },
                    prefixIcon: Icons.stadium,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date Selection
          PremiumFormSection(
            title: l10n.selectDate,
            icon: Icons.calendar_today,
            children: [
              DateSelector(
                selectedDate: selectedDate,
                onDateSelected: onDateChanged,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Time Slot Selection
          PremiumFormSection(
            title: l10n.selectTime,
            icon: Icons.access_time,
            children: [
              PremiumTimeSlotGrid(
                timeSlots: timeSlots,
                selectedSlotId: selectedTimeSlotId,
                onSlotSelected: onTimeSlotSelected,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price
          PremiumFormSection(
            title: l10n.priceLabel,
            icon: Icons.attach_money,
            children: [
              PremiumFormField(
                label: l10n.totalPriceLabel,
                hintText: l10n.enterPriceHint,
                controller: priceController,
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
